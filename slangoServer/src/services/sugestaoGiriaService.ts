import { supabase } from '../dbConnection';
import { SugestaoGiria, DadosCriacaoSugestao, DadosAprovacaoSugestao, StatusSugestao } from '../types/Jogo';
import fs from 'fs/promises';
import path from 'path';

export async function criarSugestao(
  dados: DadosCriacaoSugestao,
  usuarioId?: number
): Promise<void> {
  const { error } = await supabase
    .from('sugestoes_girias')
    .insert([{
      usuario_id: usuarioId ?? null,
      nome: dados.nome,
      significado: dados.significado,
      exemplo: dados.exemplo,
      impacto: dados.impacto,
      impacto_motivo: dados.impacto_motivo,
      tags: dados.tags,
      classe_gramatical: dados.classe_gramatical,
      status: 'PENDENTE'
    }]);

  if (error) throw new Error(error.message);
}

export async function listarSugestoes(status?: StatusSugestao): Promise<SugestaoGiria[]> {
  let query = supabase.from('sugestoes_girias').select('*').order('criado_em', { ascending: false });

  if (status) {
    query = query.eq('status', status);
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);

  return data as SugestaoGiria[];
}

async function buscarSugestaoPorId(id: number): Promise<SugestaoGiria | null> {
  const { data, error } = await supabase
    .from('sugestoes_girias')
    .select('*')
    .eq('id', id)
    .maybeSingle();

  if (error) throw new Error(error.message);
  return data as SugestaoGiria | null;
}

export async function aprovarSugestao(
  id: number,
  ajustes?: DadosAprovacaoSugestao
): Promise<{ sucesso: boolean; mensagem: string }> {
  const sugestao = await buscarSugestaoPorId(id);
  if (!sugestao) {
    return { sucesso: false, mensagem: 'Sugestão não encontrada.' };
  }
  if (sugestao.status !== 'PENDENTE') {
    return { sucesso: false, mensagem: 'Esta sugestão já foi analisada.' };
  }

  // Mescla os dados originais com os ajustes feitos pelo moderador
  const giriaFinal = {
    nome: ajustes?.nome ?? sugestao.nome,
    significado: ajustes?.significado ?? sugestao.significado,
    exemplo: ajustes?.exemplo ?? sugestao.exemplo,
    impacto: ajustes?.impacto ?? sugestao.impacto,
    impacto_motivo: ajustes?.impacto_motivo ?? sugestao.impacto_motivo,
    tags: ajustes?.tags ?? sugestao.tags,
    classe_gramatical: ajustes?.classe_gramatical ?? sugestao.classe_gramatical,
  };

  // 1. Injeta na base oficial de gírias (por tag/categoria)
  await injetarGiriaNoJson(giriaFinal);

  // 2. Atualiza status da sugestão
  const { error } = await supabase
    .from('sugestoes_girias')
    .update({ status: 'APROVADO' })
    .eq('id', id);

  if (error) throw new Error(error.message);

  return { sucesso: true, mensagem: 'Gíria aprovada e inserida na base oficial com sucesso!' };
}

export async function rejeitarSugestao(id: number): Promise<{ sucesso: boolean; mensagem: string }> {
  const sugestao = await buscarSugestaoPorId(id);
  if (!sugestao) {
    return { sucesso: false, mensagem: 'Sugestão não encontrada.' };
  }

  const { error } = await supabase
    .from('sugestoes_girias')
    .update({ status: 'REJEITADO' })
    .eq('id', id);

  if (error) throw new Error(error.message);

  return { sucesso: true, mensagem: 'Sugestão rejeitada.' };
}

// Grava a gíria aprovada no(s) JSON(s) correspondente(s) às tags
async function injetarGiriaNoJson(giria: DadosCriacaoSugestao) {
  const proximoId = Date.now(); // troque por uma estratégia de ID real (sequence, contador no banco etc.)

  const objetoGiria = {
    id: proximoId,
    nome: giria.nome,
    variacoes: [],
    classe_gramatical: giria.classe_gramatical ?? 'expressao',
    significado: giria.significado,
    tags: giria.tags,
    permissao: 'livre',
    impacto: giria.impacto,
    impacto_motivo: giria.impacto_motivo,
    exemplo_correto: giria.exemplo,
    exemplos_incorretos: [],
    significados_incorretos: []
  };

  for (const tag of giria.tags) {
    const caminhoArquivo = path.join(__dirname, '..', 'utils', 'girias', `${tag}.json`);

    let conteudo: any[] = [];
    try {
      const bruto = await fs.readFile(caminhoArquivo, 'utf-8');
      conteudo = JSON.parse(bruto);
    } catch {
      // Arquivo da categoria ainda não existe — cria do zero
      conteudo = [];
    }

    conteudo.push(objetoGiria);
    await fs.writeFile(caminhoArquivo, JSON.stringify(conteudo, null, 2), 'utf-8');
  }
}