import { supabase } from '../dbConnection';

// ─────────────────────────────────────────────────────────────
// Tipos da tabela `sugestoes_girias`
// ─────────────────────────────────────────────────────────────
export type StatusSugestao = 'PENDENTE' | 'APROVADO' | 'REJEITADO';

export interface SugestaoGiria {
    id: number | string;
    usuario_id: number;
    nome: string;
    significado: string;
    exemplo: string;
    impacto: string;
    impacto_motivo: string;
    classe_gramatical: string;
    status: StatusSugestao;
    criado_em: string;
    descricao_adm: string | null;
    quem_aceitou: string | null;
}

/** Payload aceito na criação de uma sugestão pelo usuário. */
export interface NovaSugestao {
    nome: string;
    significado: string;
    exemplo: string;
    impacto: string;
    impacto_motivo: string;
    classe_gramatical: string;
}

// ─────────────────────────────────────────────────────────────
// Helpers de autorização
// ─────────────────────────────────────────────────────────────

/** Retorna dados mínimos do usuário para checar se ele pode moderar. */
export async function buscarPerfilBasicoUsuario(
    idUsuario: number
): Promise<{ id: number; Nome: string; Administrador: boolean } | null> {
    const { data, error } = await supabase
        .from('User')
        .select('id, Nome, Administrador')
        .eq('id', idUsuario)
        .maybeSingle();

    if (error) throw new Error(error.message);
    return data as { id: number; Nome: string; Administrador: boolean } | null;
}

// ─────────────────────────────────────────────────────────────
// CRUD de sugestões
// ─────────────────────────────────────────────────────────────

export async function criarSugestao(
    idUsuario: number,
    dados: NovaSugestao
): Promise<SugestaoGiria> {
    const registro = {
        usuario_id: idUsuario,
        nome: dados.nome.trim(),
        significado: dados.significado.trim(),
        exemplo: dados.exemplo.trim(),
        impacto: dados.impacto.trim(),
        impacto_motivo: dados.impacto_motivo.trim(),
        classe_gramatical: dados.classe_gramatical.trim(),
        status: 'PENDENTE' as StatusSugestao,
        descricao_adm: null,
        quem_aceitou: null,
    };

    const { data, error } = await supabase
        .from('sugestoes_girias')
        .insert([registro])
        .select()
        .single();

    if (error) throw new Error(error.message);
    return data as SugestaoGiria;
}

/** Histórico do usuário logado (todas as sugestões que ele enviou). */
export async function listarSugestoesDoUsuario(
    idUsuario: number
): Promise<SugestaoGiria[]> {
    const { data, error } = await supabase
        .from('sugestoes_girias')
        .select('*')
        .eq('usuario_id', idUsuario)
        .order('criado_em', { ascending: false });

    if (error) throw new Error(error.message);
    return (data ?? []) as SugestaoGiria[];
}

/** Fila de moderação: sugestões pendentes de todos os usuários. */
export async function listarSugestoesPendentes(): Promise<
    Array<SugestaoGiria & { proponente_nome?: string | null }>
> {
    const { data, error } = await supabase
        .from('sugestoes_girias')
        .select('*')
        .eq('status', 'PENDENTE')
        .order('criado_em', { ascending: true });

    if (error) throw new Error(error.message);

    const sugestoes = (data ?? []) as SugestaoGiria[];
    if (sugestoes.length === 0) return [];

    // Traz o nome do proponente para exibir no painel de moderação.
    const idsUnicos = Array.from(new Set(sugestoes.map((s) => s.usuario_id)));
    const { data: usuarios } = await supabase
        .from('User')
        .select('id, Nome')
        .in('id', idsUnicos);

    const mapaNomes = new Map<number, string>();
    (usuarios ?? []).forEach((u: any) => mapaNomes.set(u.id, u.Nome));

    return sugestoes.map((s) => ({
        ...s,
        proponente_nome: mapaNomes.get(s.usuario_id) ?? null,
    }));
}

/**
 * Modera uma sugestão. Só admin (`Responsavel = true`) pode chamar.
 * `descricao_adm` é obrigatória — a regra de negócio da tela também exige,
 * mas validamos aqui para não confiar só no cliente.
 */
export async function moderarSugestao(
    idSugestao: number | string,
    idAdmin: number,
    novoStatus: 'APROVADO' | 'REJEITADO',
    descricaoAdm: string
): Promise<SugestaoGiria> {
    if (!descricaoAdm || descricaoAdm.trim().length === 0) {
        throw new Error('DESCRICAO_ADM_OBRIGATORIA');
    }

    const admin = await buscarPerfilBasicoUsuario(idAdmin);
    if (!admin) throw new Error('ADMIN_NAO_ENCONTRADO');
    if (!admin.Administrador) throw new Error('SEM_PERMISSAO');

    const { data: existente, error: erroBusca } = await supabase
    .from('sugestoes_girias')
    .select('id, status')
    .eq('id', idSugestao)
    .maybeSingle();

    if (erroBusca) throw new Error(erroBusca.message);
    if (!existente) throw new Error('SUGESTAO_NAO_ENCONTRADA');
    if (existente.status !== 'PENDENTE') {
        throw new Error('SUGESTAO_JA_MODERADA');
    }

    const { data, error } = await supabase
        .from('sugestoes_girias')
        .update({
            status: novoStatus,
            descricao_adm: descricaoAdm.trim(),
            quem_aceitou: admin.Nome,
        })
        .eq('id', idSugestao)
        .select()
        .single();

    if (error) throw new Error(error.message);
    return data as SugestaoGiria;
}
