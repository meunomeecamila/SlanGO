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
    giriasDaRodada: any[], // Recebe os IDs da rodada
    pontuacaoObtida: number,
    pontuacaoMaxima: number = 9
): Promise<{ salvou: boolean; percentualAcerto: number }> {
    
    const idMundo = await buscarIdMundoPorNome(nomeDoMundo);
    if (idMundo === null) {
        throw new Error(`Mundo '${nomeDoMundo}' não encontrado.`);
    }

    const percentualAcerto = pontuacaoObtida / pontuacaoMaxima;

    // Se não atingir 80%, não salva progresso
    if (percentualAcerto < 0.8) {
        return { salvou: false, percentualAcerto };
    }

    // 1. Puxa o que ele já aprendeu (isso retorna um array de strings)
    const giriasJaAprendidas = await buscarGiriasAprendidas(idMundo, idUser);

    // 2. Garante que os itens novos recebidos do Flutter também sejam strings 
    const rodadaStrings = giriasDaRodada.map(String);

    // 3. Mescla as duas listas e remove duplicatas com Set
    // Ex: ["1", "2"] + ["2", "3", "4"] = ["1", "2", "3", "4"]
    const novaListaGirias = Array.from(new Set([...giriasJaAprendidas, ...rodadaStrings]));

    // 4. Salva a nova quantidade (A quantidade vai acumulando perfeitamente)
    const payload = {
        id_Mundo: idMundo,
        id_User: idUser,
        Girias_Aprendidas: novaListaGirias.join(', '), // Salva "1, 2, 3, 4"
        Progresso: percentualAcerto,
        Quantidade_Aprendida: novaListaGirias.length,  // Soma o total acumulado
    };

    const { error } = await supabase
        .from('user_mundo') // Substitua pela sua TABELA_PROGRESSO
        .upsert([payload], { onConflict: 'id_Mundo,id_User' });

    if (error) {
        console.error('Erro ao salvar progresso:', error);
        throw new Error('Não foi possível salvar o progresso.');
    }

    return { salvou: true, percentualAcerto };
}