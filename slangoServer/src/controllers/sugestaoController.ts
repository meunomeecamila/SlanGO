import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware';
import {
    criarSugestao,
    listarSugestoesDoUsuario,
    listarSugestoesPendentes,
    moderarSugestao,
    buscarPerfilBasicoUsuario,
    NovaSugestao,
} from '../services/sugestaoService';

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

async function garantirAdmin(idUsuario: number): Promise<boolean> {
    const perfil = await buscarPerfilBasicoUsuario(idUsuario);
    return !!perfil?.Administrador;
}

const CAMPOS_OBRIGATORIOS: Array<keyof NovaSugestao> = [
    'nome',
    'significado',
    'exemplo',
    'impacto',
    'impacto_motivo',
    'classe_gramatical',
];

function validarCamposSugestao(body: any): { ok: true; dados: NovaSugestao } | { ok: false; erro: string } {
    const faltantes: string[] = [];
    for (const campo of CAMPOS_OBRIGATORIOS) {
        const v = body?.[campo];
        if (typeof v !== 'string' || v.trim().length === 0) faltantes.push(campo);
    }
    if (faltantes.length > 0) {
        return { ok: false, erro: `Campos obrigatórios ausentes: ${faltantes.join(', ')}` };
    }
    return {
        ok: true,
        dados: {
            nome: body.nome,
            significado: body.significado,
            exemplo: body.exemplo,
            impacto: body.impacto,
            impacto_motivo: body.impacto_motivo,
            classe_gramatical: body.classe_gramatical,
        },
    };
}

// ─────────────────────────────────────────────────────────────
// Endpoints
// ─────────────────────────────────────────────────────────────

export const enviarSugestao = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const validacao = validarCamposSugestao(req.body);
        if (!validacao.ok) {
            return res.status(400).json({ erro: validacao.erro });
        }

        const sugestao = await criarSugestao(idUsuario, validacao.dados);
        return res.status(201).json({ sucesso: true, sugestao });
    } catch (e: any) {
        return res.status(500).json({ erro: e.message ?? 'Erro ao enviar sugestão.' });
    }
};

export const historicoDoUsuario = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const sugestoes = await listarSugestoesDoUsuario(idUsuario);
        return res.status(200).json({ sucesso: true, sugestoes });
    } catch (e: any) {
        return res.status(500).json({ erro: e.message ?? 'Erro ao buscar histórico.' });
    }
};

export const listarPendentes = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idAdmin = req.usuario!.id!;
        const isAdmin = await garantirAdmin(idAdmin);
        if (!isAdmin) {
            return res.status(403).json({ erro: 'Apenas administradores acessam esta rota.' });
        }

        const sugestoes = await listarSugestoesPendentes();
        return res.status(200).json({ sucesso: true, sugestoes });
    } catch (e: any) {
        return res.status(500).json({ erro: e.message ?? 'Erro ao listar pendentes.' });
    }
};

export const moderar = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idAdmin = req.usuario!.id!;
        const { id } = req.params;
        const { status, descricao_adm } = req.body ?? {};

        if (status !== 'APROVADO' && status !== 'REJEITADO') {
            return res.status(400).json({ erro: 'Status inválido. Use APROVADO ou REJEITADO.' });
        }
        if (typeof descricao_adm !== 'string' || descricao_adm.trim().length === 0) {
            return res.status(400).json({ erro: 'descricao_adm é obrigatória.' });
        }

        const sugestao = await moderarSugestao(Number(id), idAdmin, status, descricao_adm);
        return res.status(200).json({ sucesso: true, sugestao });
    } catch (e: any) {
        const msg = e.message ?? '';
        if (msg === 'DESCRICAO_ADM_OBRIGATORIA') {
            return res.status(400).json({ erro: 'descricao_adm é obrigatória.' });
        }
        if (msg === 'SEM_PERMISSAO') {
            return res.status(403).json({ erro: 'Apenas administradores podem moderar.' });
        }
        if (msg === 'SUGESTAO_NAO_ENCONTRADA') {
            return res.status(404).json({ erro: 'Sugestão não encontrada.' });
        }
        if (msg === 'SUGESTAO_JA_MODERADA') {
            return res.status(409).json({ erro: 'Sugestão já foi moderada anteriormente.' });
        }
        return res.status(500).json({ erro: msg || 'Erro ao moderar sugestão.' });
    }
};
