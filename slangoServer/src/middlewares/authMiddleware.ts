import { Request, Response, NextFunction } from 'express';
import { verificarToken } from '../services/authService';

export interface RequisicaoAutenticada extends Request {
    usuario?: { id: number; email: string };
}

export function autenticar(req: RequisicaoAutenticada, res: Response, next: NextFunction) {
    const authHeader = req.headers.authorization;

    if (!authHeader?.startsWith('Bearer ')) {
        return res.status(401).json({ erro: 'Token não fornecido' });
    }

    const token = authHeader.split(' ')[1];

    try {
        const payload = verificarToken(token);
        req.usuario = { id: payload.id, email: payload.email };
        next();
    } catch {
        return res.status(401).json({ erro: 'Token inválido ou expirado' });
    }
}