import { Request, Response } from 'express';
import { validarCredenciais } from '../services/usuarioService';
import { 
    gerarToken,
    gerarTokenConvidado
} from '../services/authService';

export const login = async (req: Request, res: Response) => {
    try {
        const { email, senha } = req.body;

        const usuario = await validarCredenciais(email, senha);
        if (!usuario) {
            return res.status(401).json({ erro: 'Email ou senha inválidos' });
        }

        const token = gerarToken({ id: usuario.id, email: usuario.Email });

        res.status(200).json({
            token,
            usuario: { id: usuario.id, nome: usuario.Nome, email: usuario.Email }
        });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export function criarSessaoConvidado(req: Request, res: Response) {
    const token = gerarTokenConvidado();

    res.status(200).json({
        sucesso: true,
        token,
    });
}