import { supabase } from '../dbConnection';
import { RegistroRanking, ItemRanking, PosicaoUsuario } from '../types/Jogo';

export async function registrarResultado(registro: RegistroRanking): Promise<void> {
  const { error } = await supabase
    .from('ranking_rodadas')
    .insert([{
      id_User: registro.idUsuario,
      id_Mundo: registro.idMundo,
      Tempo_Ms: registro.tempoMs,
      Pontuacao: registro.pontuacao,
      Percentual_Acerto: registro.percentualAcerto,
    }]);

  if (error) throw new Error(error.message);
}

export async function buscarLeaderboard(idMundo: number, limite = 20): Promise<ItemRanking[]> {
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

export async function buscarPosicaoUsuario(idUsuario: number, idMundo: number): Promise<PosicaoUsuario> {
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