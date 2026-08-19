import { supabase } from '../dbConnection';
import { ItemRanking, PosicaoUsuario } from '../types/Jogo';

const TOTAL_PERGUNTAS_QUIZ = 9; // mesmo valor fixo da correção do bug totalGiriasMundo

interface ResultadoRegistro {
  registrado: boolean;   // fez 9/9 nessa tentativa (quiz perfeito)
  melhorou: boolean;     // essa tentativa bateu (ou criou) o recorde pessoal
  percentualAcerto: number;
  pontuacao: number;
  melhorTempoMs: number; // o que está salvo no banco AGORA (pode ser o recorde antigo, se não melhorou)
}

/**
 * Registra o resultado de uma rodada perfeita (9/9) no ranking.
 *
 * Mantém APENAS UMA linha por usuário em `ranking_rodadas` — não insere
 * uma linha nova a cada tentativa. Se o usuário já tem um tempo salvo,
 * só sobrescreve quando o novo tempo é MENOR (melhor) que o recorde atual.
 *
 * Pré-requisito no banco: constraint de unicidade em `id_User`, ex:
 *   ALTER TABLE ranking_rodadas ADD CONSTRAINT ranking_rodadas_id_user_unique UNIQUE ("id_User");
 * Sem isso, o `.upsert(..., { onConflict: 'id_User' })` abaixo não funciona.
 */
export async function registrarTempoRankeado(
  idUsuario: number,
  idMundo: number,
  nomeUsuario: string,
  tempoMs: number,
  acertos: number
): Promise<ResultadoRegistro> {
  const percentualAcerto = acertos / TOTAL_PERGUNTAS_QUIZ;
  const segundosGastos = Math.floor(tempoMs / 1000);
  const pontuacao = Math.max(0, acertos * 1000 - segundosGastos);

  // Só entra no ranking quem acerta tudo — qualquer erro desqualifica a tentativa.
  if (acertos !== TOTAL_PERGUNTAS_QUIZ) {
    return {
      registrado: false,
      melhorou: false,
      percentualAcerto,
      pontuacao,
      melhorTempoMs: tempoMs,
    };
  }

  // Busca o recorde atual do usuário (se existir alguma linha pra ele).
  const { data: existente, error: erroSelect } = await supabase
    .from('ranking_rodadas')
    .select('Tempo_Ms')
    .eq('id_User', idUsuario)
    .maybeSingle();

  if (erroSelect) throw new Error(erroSelect.message);

  const melhorou = !existente || tempoMs < existente.Tempo_Ms;

  if (melhorou) {
    const { error: erroUpsert } = await supabase
      .from('ranking_rodadas')
      .upsert(
        [
          {
            id_User: idUsuario,
            id_Mundo: idMundo,
            nomeUsuario,
            Tempo_Ms: tempoMs,
            Pontuacao: pontuacao,
            Percentual_Acerto: percentualAcerto,
          },
        ],
        { onConflict: 'id_User' }
      );

    if (erroUpsert) throw new Error(erroUpsert.message);
  }

  return {
    registrado: true,
    melhorou,
    percentualAcerto,
    pontuacao,
    melhorTempoMs: melhorou ? tempoMs : existente!.Tempo_Ms,
  };
}

// Leaderboard GLOBAL, ordenado só por tempo (menor tempo = melhor posição).
// Como cada usuário tem no máximo UMA linha na tabela (graças ao upsert
// acima), não precisa de agregação nenhuma — só ordenar e paginar.
export async function buscarRankingGlobal(limite = 500): Promise<ItemRanking[]> {
  const { data, error } = await supabase
    .from('ranking_rodadas')
    .select('id_User, nomeUsuario, Tempo_Ms, Pontuacao')
    .order('Tempo_Ms', { ascending: true })
    .limit(limite);

  if (error) throw new Error(error.message);

  return (data ?? []).map((linha: any, index: number) => ({
    posicao: index + 1,
    idUsuario: linha.id_User,
    nomeUsuario: linha.nomeUsuario,
    melhorTempoMs: linha.Tempo_Ms,
    pontuacao: linha.Pontuacao,
  }));
}

export async function buscarPosicaoGlobalDoUsuario(idUsuario: number): Promise<PosicaoUsuario> {
  const { data, error } = await supabase
    .from('ranking_rodadas')
    .select('id_User, Tempo_Ms')
    .order('Tempo_Ms', { ascending: true });

  if (error) throw new Error(error.message);

  const linhas = data ?? [];
  const totalJogadores = linhas.length;
  const indice = linhas.findIndex((linha: any) => linha.id_User === idUsuario);

  if (indice === -1) {
    return { posicao: null, nomeUsuario: '', melhorTempoMs: null, totalJogadores };
  }

  return {
    posicao: indice + 1,
    nomeUsuario: '',
    melhorTempoMs: linhas[indice].Tempo_Ms,
    totalJogadores,
  };
}