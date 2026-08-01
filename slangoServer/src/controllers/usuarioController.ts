import { Request, Response } from 'express';
import {
    criarUsuario,
} from '../services/usuarioService';

export const criarUsuarioController = async (req: Request, res: Response) => {
    try {
        const { nome, email, senha, confirmarSenha, responsavel } = req.body;

        if (!nome || !email || !senha || !confirmarSenha) {
            return res.status(400).json({ erro: 'Nome, email, senha e confirmação de senha são obrigatórios.' });
        }

        if (senha !== confirmarSenha) {
            return res.status(400).json({ erro: 'As senhas não coincidem.' });
        }

        const usuarioCriado = await criarUsuario({ nome, email, senha, responsavel });

        res.status(201).json({
            sucesso: true,
            usuario: usuarioCriado 
        });
    } catch (error: any) {
        if (error.message === 'EMAIL_JA_CADASTRADO') {
            return res.status(409).json({ erro: 'Erro ao se cadastrar.' });
        }
        res.status(500).json({ erro: error.message });
    }
};