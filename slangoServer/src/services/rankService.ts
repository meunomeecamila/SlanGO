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

  const linhas = data ?? [];

  const ranking: ItemRanking[] = linhas.map((linha: any, index: number) => ({
    posicao: index + 1,
    idUsuario: linha.id_User,
    nomeUsuario: linha.nomeUsuario,
    melhorTempoMs: linha.Tempo_Ms,
    pontuacao: linha.Pontuacao,
  }));

  // Só busca astronauta pro pódio (top 3) — o resto da lista continua leve.
  await preencherFotosDoPodio(ranking);

  return ranking;
}

/**
 * Preenche `urlAstronauta` apenas para quem está em 1º, 2º ou 3º lugar.
 * Muta o array recebido. Não impacta o restante do ranking (posição 4+).
 */
async function preencherFotosDoPodio(ranking: ItemRanking[]): Promise<void> {
  const top3 = ranking.filter((item) => item.posicao <= 3);
  if (top3.length === 0) return;

  const idsUsuarios = top3.map((item) => item.idUsuario);

  const { data: usuarios, error: erroUsuarios } = await supabase
    .from('User')
    .select('id, id_Astronauta')
    .in('id', idsUsuarios);

  if (erroUsuarios) throw new Error(erroUsuarios.message);

  const idsAstronautas = (usuarios ?? [])
    .map((u: any) => u.id_Astronauta)
    .filter((id: any) => id !== null && id !== undefined);

  if (idsAstronautas.length === 0) return;

  const { data: astronautas, error: erroAstronautas } = await supabase
    .from('Astronauta')
    .select('id, url_astronauta')
    .in('id', idsAstronautas);

  if (erroAstronautas) throw new Error(erroAstronautas.message);

  const mapaUsuarioParaAstronautaId = new Map<number, number>(
    (usuarios ?? []).map((u: any) => [u.id, u.id_Astronauta])
  );
  const mapaAstronautaIdParaUrl = new Map<number, string>(
    (astronautas ?? []).map((a: any) => [a.id, a.url_astronauta])
  );

  for (const item of top3) {
    const idAstronauta = mapaUsuarioParaAstronautaId.get(item.idUsuario);
    if (idAstronauta) {
      item.urlAstronauta = mapaAstronautaIdParaUrl.get(idAstronauta) ?? null;
    }
  }
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