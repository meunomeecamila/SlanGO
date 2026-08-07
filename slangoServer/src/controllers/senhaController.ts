import { Request, Response } from 'express';
import {
    buscarUsuarioPorEmail,
    validarRespostaSeguranca,
    atualizarSenhaUsuario,
} from '../services/senhaService';
import { emailValido, senhaValida } from '../utils/validador'; 

export const obterPerguntaSeguranca = async (req: Request, res: Response) => {
    try {
        const { email } = req.query as { email: string };

        if (!email) {
            return res.status(400).json({ erro: 'E-mail é obrigatório.' });
        }

        if (!emailValido(email)) {
            return res.status(400).json({ erro: 'Formato de e-mail inválido.' });
        }

        const usuario = await buscarUsuarioPorEmail(email);

        if (!usuario) {
            return res.status(404).json({ erro: 'E-mail ou resposta de segurança inválidos.' });
        }

        return res.status(200).json({
            sucesso: true,
            perguntaSeguranca: usuario.perguntaSeguranca,
        });

    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export const recuperarSenhaController = async (req: Request, res: Response) => {
    try {
        const { email, novaSenha, confirmarNovaSenha, respostaSeguranca } = req.body;

        if (!email || !novaSenha || !confirmarNovaSenha || !respostaSeguranca) {
            return res.status(400).json({ erro: 'Todos os campos são obrigatórios.' });
        }

        if (novaSenha !== confirmarNovaSenha) {
            return res.status(400).json({ erro: 'As senhas não coincidem.' });
        }

        // 3. Formato do e-mail
        if (!emailValido(email)) {
            return res.status(400).json({ erro: 'Formato de e-mail inválido.' });
        }
        const resultadoSenha = senhaValida(novaSenha);
        if (!resultadoSenha.valida) {
            return res.status(400).json({ erro: resultadoSenha.erro });
        }

        const usuario = await buscarUsuarioPorEmail(email);

        if (!usuario) {
            return res.status(400).json({ erro: 'E-mail ou resposta de segurança inválidos.' });
        }

        const respostaCorreta = await validarRespostaSeguranca(
            respostaSeguranca,
            usuario.respostaSeguranca
        );

        if (!respostaCorreta) {
            return res.status(400).json({ erro: 'E-mail ou resposta de segurança inválidos.' });
        }

        await atualizarSenhaUsuario(usuario.id, novaSenha);

        return res.status(200).json({
            sucesso: true,
            mensagem: 'Senha atualizada com sucesso.',
        });

    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};