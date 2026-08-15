import { Request, Response, NextFunction } from 'express';
import { verificarToken } from '../services/authService';
import { buscarUsuarioPorId } from '../services/usuarioService';
export interface RequisicaoAutenticada extends Request {
    usuario?: {
        id?: number;
        email?: string;
        convidado: boolean;
    };
}

export function autenticar(req: RequisicaoAutenticada, res: Response, next: NextFunction) {
    const authHeader = req.headers.authorization;

    if (!authHeader?.startsWith('Bearer ')) {
        return res.status(401).json({ erro: 'Token não fornecido' });
    }

    const token = authHeader.split(' ')[1];

    try {
        const payload = verificarToken(token);

        if (payload.convidado) {
            req.usuario = { convidado: true };
        } else {
            req.usuario = { id: payload.id, email: payload.email, convidado: false };
        }

        next();
    } catch {
        return res.status(401).json({ erro: 'Token inválido ou expirado' });
    }
}

export function bloquearConvidado(req: RequisicaoAutenticada, res: Response, next: NextFunction) {
    if (req.usuario?.convidado) {
        return res.status(403).json({ erro: 'Crie uma conta para jogar.' });
    }
    next();
}

export async function exigeAdmin(req: RequisicaoAutenticada, res: Response, next: NextFunction) {
  try {
    const idUsuario = req.usuario?.id;

    if (!idUsuario) {
      return res.status(401).json({ erro: 'Autenticação necessária.' });
    }

    const usuario = await buscarUsuarioPorId(idUsuario);

    if (!usuario || !usuario.Administrador) {
      return res.status(403).json({ erro: 'Acesso restrito a administradores.' });
    }

    next();
  } catch (error) {
    return res.status(500).json({ erro: 'Erro ao validar permissão de administrador.' });
  }
}