import { supabase } from '../dbConnection';
import { ItemRanking, PosicaoUsuario } from '../types/Jogo';

const TOTAL_PERGUNTAS_QUIZ = 9; // mesmo valor fixo da correção do bug totalGiriasMundo

interface ResultadoRegistro {
  registrado: boolean;
  percentualAcerto: number;
  pontuacao: number;
}

export async function registrarTempoRankeado(
  idUsuario: number,
  idMundo: number,
  tempoMs: number,
  acertos: number
): Promise<ResultadoRegistro> {
  const percentualAcerto = acertos / TOTAL_PERGUNTAS_QUIZ;
  const segundosGastos = Math.floor(tempoMs / 1000);
  const pontuacao = Math.max(0, acertos * 1000 - segundosGastos);

  // Só entra no ranking quem acerta tudo — qualquer erro desqualifica a tentativa.
  if (acertos !== TOTAL_PERGUNTAS_QUIZ) {
    return { registrado: false, percentualAcerto, pontuacao };
  }

  const { error } = await supabase
    .from('ranking_rodadas')
    .insert([{
      id_User: idUsuario,
      id_Mundo: idMundo, // mantido só para estatística/depuração, não filtra o leaderboard
      Tempo_Ms: tempoMs,
      Pontuacao: pontuacao,
      Percentual_Acerto: percentualAcerto,
    }]);

  if (error) throw new Error(error.message);

  return { registrado: true, percentualAcerto, pontuacao };
}

// Leaderboard GLOBAL — junta todos os mundos, melhor pontuação por usuário.
export async function buscarRankingGlobal(limite = 500): Promise<ItemRanking[]> {
  const { data, error } = await supabase.rpc('leaderboard_global', {
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

export async function buscarPosicaoGlobalDoUsuario(idUsuario: number): Promise<PosicaoUsuario> {
  const { data, error } = await supabase.rpc('posicao_usuario_global', {
    p_id_usuario: idUsuario,
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