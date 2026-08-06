import { Request, Response } from 'express';
import {
    buscarUsuarioPorEmail,
    validarRespostaSeguranca,
    atualizarSenhaUsuario
} from '../services/senhaService';

import { senhaValida } from '../utils/validador';

export const obterPerguntaSeguranca = async (req: Request, res: Response) => {
    try {
        const { email } = req.query as { email: string };

        if (!email) {
            return res.status(400).json({ erro: 'E-mail é obrigatório.' });
        }

        const usuario = await buscarUsuarioPorEmail(email);

        if (!usuario) {
            // mesmo status/formato do caso de sucesso pra não vazar se o email existe
            return res.status(404).json({ erro: "Email não encontrado." });
        }

        return res.status(200).json({
            sucesso: true,
            perguntaSeguranca: usuario.perguntaSeguranca,
        });

    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

// ==========================================
// PASSO 2 — POST /recuperar-senha
// Valida a resposta de segurança e troca a senha.
// ==========================================
export const recuperarSenhaController = async (req: Request, res: Response) => {
    try {
        const { email, novaSenha, confirmarNovaSenha, respostaSeguranca } = req.body;

        if (!email || !novaSenha || !confirmarNovaSenha || !respostaSeguranca) {
            return res.status(400).json({ erro: 'Todos os campos são obrigatórios.' });
        }

        if (novaSenha !== confirmarNovaSenha) {
            return res.status(400).json({ erro: 'As senhas não coincidem.' });
        }

        if (!senhaValida(novaSenha)) {
            return res.status(400).json({
                erro: 'A senha deve ter no mínimo 8 caracteres, incluindo letras e números.',
            });
        }
        
        const usuario = await buscarUsuarioPorEmail(email);

        if (!usuario) {
            return res.status(400).json({ erro: "Email não encontrado." });
        }

        const respostaCorreta = await validarRespostaSeguranca(
            respostaSeguranca,
            usuario.respostaSeguranca
        );

        if (!respostaCorreta) {
            return res.status(400).json({ erro: "Resposta de segurança incorreta." });
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