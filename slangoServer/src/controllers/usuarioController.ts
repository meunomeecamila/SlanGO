import { Request, Response } from 'express';
import {
    criarUsuario,
    buscarUsuarioPorId,
    atualizarUsuario,
    deletarUsuario,
    dataNascimentoValida,
    alterarSenhaUsuario
} from '../services/usuarioService';
import { emailValido, senhaValida } from '../utils/validador';

export const criarUsuarioController = async (req: Request, res: Response) => {
    try {
        const { nome, email, senha, confirmarSenha, responsavel, dataNascimento, perguntaSeguranca, respostaSeguranca } = req.body;

        if (!nome || !email || !senha || !confirmarSenha || !dataNascimento) {
            return res.status(400).json({ erro: 'Nome, email, senha, confirmação de senha e data de nascimento são obrigatórios.' });
        }

        const validacaoIdade = dataNascimentoValida(dataNascimento);
        if (!validacaoIdade.valida) {
            return res.status(400).json({ erro: validacaoIdade.erro });
        }

        if (!emailValido(email)) {
            return res.status(400).json({ erro: 'Email inválido.' });
        }

        if (senha !== confirmarSenha) {
            return res.status(400).json({ erro: 'As senhas não coincidem.' });
        }

        const validacaoSenha = senhaValida(senha);
        if (!validacaoSenha.valida) {
            return res.status(400).json({ erro: validacaoSenha.erro });
        }

        if(!perguntaSeguranca || !respostaSeguranca) {
            return res.status(400).json({ erro: 'Pergunta e resposta de segurança são obrigatórias.' });
        }

        const usuarioCriado = await criarUsuario({ Nome: nome, Email: email, Senha: senha, Responsavel: responsavel , Data: dataNascimento, perguntaSeguranca: perguntaSeguranca, respostaSeguranca: respostaSeguranca });

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
        const { nome, email, senha, responsavel, dataNascimento, perguntaSeguranca, respostaSeguranca } = req.body;

        const usuarioAtualizado = await atualizarUsuario(Number(id), {
            Nome: nome,
            Email: email,
            Senha: senha,
            Responsavel: responsavel,
            Data: dataNascimento,
            perguntaSeguranca,
            respostaSeguranca,
        });

        if (!usuarioAtualizado) {
            return res.status(404).json({ erro: 'Usuário não encontrado.' });
        }

        res.status(200).json({ sucesso: true, usuario: usuarioAtualizado });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export const alterarSenhaController = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { senhaAtual, novaSenha, confirmarNovaSenha } = req.body;

        if (!senhaAtual || !novaSenha || !confirmarNovaSenha) {
            return res.status(400).json({ erro: 'Todos os campos são obrigatórios.' });
        }

        if (novaSenha !== confirmarNovaSenha) {
            return res.status(400).json({ erro: 'As senhas não coincidem.' });
        }

        const resultadoSenha = senhaValida(novaSenha);
        if (!resultadoSenha.valida) {
            return res.status(400).json({ erro: resultadoSenha.erro });
        }

        const senhaAlterada = await alterarSenhaUsuario(Number(id), senhaAtual, novaSenha);

        if (!senhaAlterada) {
            return res.status(401).json({ erro: 'Senha atual incorreta.' });
        }

        res.status(200).json({ sucesso: true, mensagem: 'Senha alterada com sucesso.' });
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