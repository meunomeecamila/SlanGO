import { supabase } from '../dbConnection';
import { verificarEDesbloquearItens } from './itemService';

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


export async function salvarProgressoUsuario(
    nomeDoMundo: string,
    idUser: number,
    giriasDaRodada: any[], // Recebe os IDs da rodada
    pontuacaoObtida: number,
    totalGiriasMundo: number, // Total de gírias cadastradas nesse mundo (ex: 45) — vem de contarGiriasPorMundos()
    pontuacaoMaxima: number = 9 // Nota máxima do QUIZ em si (sempre 9: 3 gírias x 3 fases). Não confundir com totalGiriasMundo.
): Promise<{ salvou: boolean; percentualAcerto: number; progressoMundo: number | null }> {
    
    const idMundo = await buscarIdMundoPorNome(nomeDoMundo);
    if (idMundo === null) {
        throw new Error(`Mundo '${nomeDoMundo}' não encontrado.`);
    }

    const percentualAcerto = pontuacaoObtida / pontuacaoMaxima;

    if (percentualAcerto < 0.8) {
        return { salvou: false, percentualAcerto, progressoMundo: null };
    }

    const giriasJaAprendidas = await buscarGiriasAprendidas(idMundo, idUser);


    const rodadaStrings = giriasDaRodada.map(String);

    const novaListaGirias = Array.from(new Set([...giriasJaAprendidas, ...rodadaStrings]));

    const progressoMundo = totalGiriasMundo > 0
        ? novaListaGirias.length / totalGiriasMundo
        : 0;

    const payload = {
        id_Mundo: idMundo,
        id_User: idUser,
        Girias_Aprendidas: novaListaGirias.join(', '), // Salva "1, 2, 3, 4"
        Progresso: progressoMundo,
        Quantidade_Aprendida: novaListaGirias.length,  // Soma o total acumulado
    };

    const { error } = await supabase
        .from('user_mundo') // Substitua pela sua TABELA_PROGRESSO
        .upsert([payload], { onConflict: 'id_Mundo,id_User' });

    if (error) {
        console.error('Erro ao salvar progresso:', error);
        throw new Error('Não foi possível salvar o progresso.');
    }

    try {
        await verificarEDesbloquearItens(idUser, idMundo, progressoMundo);
    } catch (erroDesbloqueio) {
        console.error('Erro ao desbloquear itens do mundo:', erroDesbloqueio);
    }

    return { salvou: true, percentualAcerto, progressoMundo };
}