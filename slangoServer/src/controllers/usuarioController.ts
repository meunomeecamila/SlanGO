import { Request, Response } from 'express';
import {
    criarUsuario,
    buscarUsuarioPorId,
    atualizarUsuario,
    deletarUsuario
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

        const usuarioCriado = await criarUsuario({ Nome: nome, Email: email, Senha: senha, Responsavel: responsavel });

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

export const buscarUsuarioController = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;

        const usuario = await buscarUsuarioPorId(Number(id));

        if (!usuario) {
            return res.status(404).json({ erro: 'Usuário não encontrado.' });
        }

        res.status(200).json({ sucesso: true, usuario });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export const atualizarUsuarioController = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { nome, email, senha, responsavel } = req.body;

        const usuarioAtualizado = await atualizarUsuario(Number(id), {
            Nome: nome,
            Email: email,
            Senha: senha,
            Responsavel: responsavel
        });

        if (!usuarioAtualizado) {
            return res.status(404).json({ erro: 'Usuário não encontrado.' });
        }

        res.status(200).json({ sucesso: true, usuario: usuarioAtualizado });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export const deletarUsuarioController = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;

        const foiDeletado = await deletarUsuario(Number(id));

        if (!foiDeletado) {
            return res.status(404).json({ erro: 'Usuário não encontrado.' });
        }

        res.status(200).json({ sucesso: true, mensagem: 'Usuário deletado com sucesso.' });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};