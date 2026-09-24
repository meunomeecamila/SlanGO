import { supabase } from '../dbConnection';
import { verificarEDesbloquearItens } from './itemService';
import { obterGiriasDoMundo } from '../utils/girias/dicionarioGirias';

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
// Ids dos mundos não mudam: guardamos em memória para não consultar o banco
// a cada requisição (antes eram ~11 consultas só para listar o progresso).
const cacheIdMundo = new Map<string, number>();

export async function buscarIdMundoPorNome(nomeDoMundo: string): Promise<number | null> {
    const chave = (nomeDoMundo ?? '').trim().toLowerCase();
    const emCache = cacheIdMundo.get(chave);
    if (emCache !== undefined) return emCache;

    const { data, error } = await supabase
        .from(TABELA_MUNDO)
        .select('id')
        .ilike('Nome', nomeDoMundo)
        .maybeSingle();

    if (error) {
        console.error('Erro ao buscar id do mundo:', error);
        return null;
    }

    if (data) cacheIdMundo.set(chave, data.id);
    return data ? data.id : null;
}

/**
 * Busca as gírias que o usuário já aprendeu (rodadas com ≥80% de acerto)
 * num mundo específico. Retorna array vazio se ele nunca "passou" nesse mundo.
 */
export async function buscarGiriasAprendidas(
    idMundo: number,
    idUser: number,
    idioma = 'pt',
): Promise<string[]> {
    const { data, error } = await supabase
        .from(TABELA_PROGRESSO)
        .select('Girias_Aprendidas')
        .eq('id_Mundo', idMundo)
        .eq('id_User', idUser)
        .eq('idioma', idioma)
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
    idUser: number,
    idioma = 'pt',
): Promise<{ progresso: number; quantidadeAprendida: number }> {
    const { data, error } = await supabase
        .from(TABELA_PROGRESSO)
        .select('Progresso, Quantidade_Aprendida')
        .eq('id_Mundo', idMundo)
        .eq('id_User', idUser)
        .eq('idioma', idioma)
        .maybeSingle();

    if (error || !data) {
        return { progresso: 0, quantidadeAprendida: 0 };
    }

    return { progresso: data.Progresso ?? 0, quantidadeAprendida: data.Quantidade_Aprendida ?? 0 };
}


/**
 * Melhor progresso que o usuário já atingiu em cada mundo, considerando TODOS
 * os idiomas. É essa métrica que decide o diploma: quem fechou 100% de um mundo
 * em qualquer idioma mantém o diploma para sempre, mesmo trocando de idioma.
 */
export async function buscarProgressoMaximoPorMundo(
    idUser: number,
): Promise<Record<number, number>> {
    const { data, error } = await supabase
        .from(TABELA_PROGRESSO)
        .select('id_Mundo, Progresso')
        .eq('id_User', idUser);

    if (error || !data) {
        if (error) console.error('Erro ao buscar progresso máximo:', error);
        return {};
    }

    const maximos: Record<number, number> = {};
    for (const linha of data) {
        const atual = maximos[linha.id_Mundo] ?? 0;
        const progresso = linha.Progresso ?? 0;
        if (progresso > atual) maximos[linha.id_Mundo] = progresso;
    }

    return maximos;
}

export async function salvarProgressoUsuario(
    nomeDoMundo: string,
    idUser: number,
    giriasDaRodada: any[], // Recebe os IDs da rodada
    pontuacaoObtida: number,
    idioma = 'pt',
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

    const giriasJaAprendidas = await buscarGiriasAprendidas(idMundo, idUser, idioma);


    const rodadaStrings = giriasDaRodada.map(String);

    const novaListaGirias = Array.from(new Set([...giriasJaAprendidas, ...rodadaStrings]));

    const totalGiriasMundo = obterGiriasDoMundo(nomeDoMundo, idioma).length;
    const progressoMundo = totalGiriasMundo > 0
        ? novaListaGirias.length / totalGiriasMundo
        : 0;

    const payload = {
        id_Mundo: idMundo,
        id_User: idUser,
        idioma,
        Girias_Aprendidas: novaListaGirias.join(', '), // Salva "1, 2, 3, 4"
        Progresso: progressoMundo,
        Quantidade_Aprendida: novaListaGirias.length,  // Soma o total acumulado
    };

    const { error } = await supabase
        .from('user_mundo') // Substitua pela sua TABELA_PROGRESSO
        .upsert([payload], { onConflict: 'id_User,id_Mundo,idioma' });

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