import { supabase } from '../dbConnection';

const TABELA_PROGRESSO = 'user_mundo';
const TABELA_MUNDO = 'Mundo';

interface ProgressoUsuario {
    id_Mundo: number;
    id_User: number;
    Girias_Aprendidas: string;
    Progresso: number;
    Quantidade_Aprendida: number;
}

/**
 * Busca o id numérico do mundo na tabela `Mundo` a partir do nome (slug) usado no código,
 * ex: 'kpop', 'esportes'. Comparação case-insensitive (ILIKE) pra não depender de
 * capitalização exata no banco.
 */
export async function buscarIdMundoPorNome(nomeDoMundo: string): Promise<number | null> {
    const { data, error } = await supabase
        .from(TABELA_MUNDO)
        .select('id')
        .ilike('Nome', nomeDoMundo)
        .maybeSingle();

    if (error) {
        console.error('Erro ao buscar id do mundo:', error);
        return null;
    }

    return data ? data.id : null;
}

/**
 * Busca as gírias que o usuário já aprendeu (rodadas com ≥80% de acerto)
 * num mundo específico. Retorna array vazio se ele nunca "passou" nesse mundo.
 */
export async function buscarGiriasAprendidas(idMundo: number, idUser: number): Promise<string[]> {
    const { data, error } = await supabase
        .from(TABELA_PROGRESSO)
        .select('Girias_Aprendidas')
        .eq('id_Mundo', idMundo)
        .eq('id_User', idUser)
        .maybeSingle(); 

    if (error) {
        console.error('Erro ao buscar gírias aprendidas:', error);
        return [];
    }

    if (!data || !data.Girias_Aprendidas) return [];

    return data.Girias_Aprendidas
        .split(',')
        .map((g: string) => g.trim())
        .filter(Boolean);
}

/**
 * Busca o progresso (%) e a quantidade aprendida de um usuário num mundo.
 * Útil pra tela do mapa mostrar a barra de progresso real em vez de valor fixo.
 */
export async function buscarProgressoDoUsuario(
    idMundo: number,
    idUser: number
): Promise<{ progresso: number; quantidadeAprendida: number }> {
    const { data, error } = await supabase
        .from(TABELA_PROGRESSO)
        .select('Progresso, Quantidade_Aprendida')
        .eq('id_Mundo', idMundo)
        .eq('id_User', idUser)
        .maybeSingle();

    if (error || !data) {
        return { progresso: 0, quantidadeAprendida: 0 };
    }

    return { progresso: data.Progresso ?? 0, quantidadeAprendida: data.Quantidade_Aprendida ?? 0 };
}

/**
 * Chamada ao final do quiz (endpoint POST /mundos/resultado).
 * Só grava progresso se o usuário acertou ≥ 80% da rodada (padrão 8/9 ou 9/9).
 * Faz merge com o que ele já tinha aprendido antes, sem duplicar gírias.
 */
export async function salvarProgressoUsuario(
    nomeDoMundo: string,
    idUser: number,
    giriasDaRodada: string[], // nomes das 3 gírias que caíram nessa rodada
    pontuacaoObtida: number,
    pontuacaoMaxima: number = 9
): Promise<{ salvou: boolean; percentualAcerto: number }> {
    const idMundo = await buscarIdMundoPorNome(nomeDoMundo);
    if (idMundo === null) {
        throw new Error(`Mundo '${nomeDoMundo}' não encontrado na tabela Mundo.`);
    }

    const percentualAcerto = pontuacaoObtida / pontuacaoMaxima;

    if (percentualAcerto < 0.8) {
        console.log(
            `Usuário ${idUser} não atingiu 80% no mundo '${nomeDoMundo}' (${(percentualAcerto * 100).toFixed(0)}%). Progresso não salvo.`
        );
        return { salvou: false, percentualAcerto };
    }

    const giriasJaAprendidas = await buscarGiriasAprendidas(idMundo, idUser);
    const novaListaGirias = Array.from(new Set([...giriasJaAprendidas, ...giriasDaRodada]));

    const payload: ProgressoUsuario = {
        id_Mundo: idMundo,
        id_User: idUser,
        Girias_Aprendidas: novaListaGirias.join(', '),
        Progresso: percentualAcerto,
        Quantidade_Aprendida: novaListaGirias.length,
    };

    // Precisa de constraint única em (id_Mundo, id_User) na tabela pro onConflict funcionar
    const { error } = await supabase
        .from(TABELA_PROGRESSO)
        .upsert([payload], { onConflict: 'id_Mundo,id_User' });

    if (error) {
        console.error('Erro ao salvar progresso do usuário:', error);
        throw new Error('Não foi possível salvar o progresso do usuário.');
    }

    console.log(`✅ Progresso salvo: usuário ${idUser} aprendeu ${novaListaGirias.length} gírias em '${nomeDoMundo}'.`);
    return { salvou: true, percentualAcerto };
}