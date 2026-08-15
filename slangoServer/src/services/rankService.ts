import { supabase } from '../dbConnection';

const TABELA_RANKING = 'ranking_rodadas';
const PONTUACAO_MAXIMA = 9; // mesmo valor fixo usado em preogressoService
const LIMIAR_APROVACAO = 0.8;


export async function registrarTempoRankeado(
    idUsuario: number,
    idMundo: number,
    tempoMs: number,
    pontuacaoObtida: number
): Promise<{ registrado: boolean; percentualAcerto: number }> {
    const percentualAcerto = pontuacaoObtida / PONTUACAO_MAXIMA;

    if (percentualAcerto < LIMIAR_APROVACAO) {
        return { registrado: false, percentualAcerto };
    }

    const { error } = await supabase
        .from(TABELA_RANKING)
        .insert([{
            id_User: idUsuario,
            id_Mundo: idMundo,
            Tempo_Ms: tempoMs,
            Pontuacao: pontuacaoObtida,
            Percentual_Acerto: percentualAcerto,
        }]);

    if (error) {
        console.error('Erro ao registrar tempo no ranking:', error);
        throw new Error('Não foi possível registrar o tempo no ranking.');
    }

    return { registrado: true, percentualAcerto };
}

export async function buscarRankingDoMundo(idMundo: number, limite: number = 20) {
    const { data, error } = await supabase.rpc('ranking_por_mundo', {
        mundo_id: idMundo,
        limite,
    });

    if (error) {
        console.error('Erro ao buscar ranking do mundo:', error);
        throw new Error('Não foi possível buscar o ranking.');
    }

    return data;
}

export async function buscarPosicaoDoUsuario(idMundo: number, idUsuario: number) {
    const { data, error } = await supabase
        .rpc('posicao_usuario_ranking', { mundo_id: idMundo, usuario_id: idUsuario })
        .maybeSingle();

    if (error) {
        console.error('Erro ao buscar posição do usuário:', error);
        throw new Error('Não foi possível buscar a posição do usuário.');
    }

    if (!data) {
        // Usuário ainda não tem nenhuma rodada aprovada (>=80%) nesse mundo
        return { posicao: null, melhorTempoMs: null, totalJogadores: 0 };
    }

    return data;
}