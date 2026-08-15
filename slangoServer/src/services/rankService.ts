import { supabase } from '../dbConnection';
import { ItemRanking, PosicaoUsuario } from '../types/Jogo';

const PERCENTUAL_MINIMO_RANKING = 0.8;

interface ResultadoRegistro {
  registrado: boolean;
  percentualAcerto: number;
}

export async function registrarTempoRankeado(
  idUsuario: number,
  idMundo: number,
  tempoMs: number,
  pontuacaoFinal: number,
  totalPerguntas = 9 // mesmo valor fixo usado na correção do bug de totalGiriasMundo
): Promise<ResultadoRegistro> {
  const percentualAcerto = totalPerguntas > 0 ? pontuacaoFinal / totalPerguntas : 0;

  if (percentualAcerto < PERCENTUAL_MINIMO_RANKING) {
    return { registrado: false, percentualAcerto };
  }

  const { error } = await supabase
    .from('ranking_rodadas')
    .insert([{
      id_User: idUsuario,
      id_Mundo: idMundo,
      Tempo_Ms: tempoMs,
      Pontuacao: pontuacaoFinal,
      Percentual_Acerto: percentualAcerto,
    }]);

  if (error) throw new Error(error.message);

  return { registrado: true, percentualAcerto };
}

export async function buscarRankingDoMundo(idMundo: number, limite = 20): Promise<ItemRanking[]> {
  const { data, error } = await supabase.rpc('leaderboard_por_mundo', {
    p_id_mundo: idMundo,
    p_limite: limite,
  });

  if (error) throw new Error(error.message);

  return (data ?? []).map((linha: any, index: number) => ({
    posicao: index + 1,
    idUsuario: linha.idUsuario,
    melhorTempoMs: linha.melhorTempoMs,
    pontuacao: linha.pontuacao,
  }));
}

export async function buscarPosicaoDoUsuario(idMundo: number, idUsuario: number): Promise<PosicaoUsuario> {
  const { data, error } = await supabase.rpc('posicao_usuario_mundo', {
    p_id_usuario: idUsuario,
    p_id_mundo: idMundo,
  });

  if (error) throw new Error(error.message);

  if (!data || data.length === 0) {
    return { posicao: null, melhorTempoMs: null, totalJogadores: 0 };
  }

  const linha = data[0];
  return {
    posicao: linha.posicao,
    melhorTempoMs: linha.melhorTempoMs,
    totalJogadores: linha.totalJogadores,
  };
}