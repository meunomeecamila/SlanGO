import { Request, Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware';
import * as sugestaoService from '../services/sugestaoGiriaService';
import { StatusSugestao } from '../types/Jogo';

export async function sugerirGiria(req: RequisicaoAutenticada, res: Response) {
    try {
        await sugestaoService.criarSugestao(req.body, req.usuario?.id);
        res.status(201).json({ sucesso: true, mensagem: 'Sugestão enviada com sucesso! Ela passará por análise.' });
    } catch (error: any) {
        res.status(400).json({ sucesso: false, mensagem: error.message });
    }
}

export async function listarSugestoes(req: Request, res: Response) {
    try {
        const status = req.query.status as StatusSugestao | undefined;
        const sugestoes = await sugestaoService.listarSugestoes(status);
        res.status(200).json({ total: sugestoes.length, sugestoes });
    } catch (error: any) {
        res.status(500).json({ sucesso: false, mensagem: error.message });
    }
}

export async function aprovarSugestao(req: Request, res: Response) {
    try {
        const resultado = await sugestaoService.aprovarSugestao(Number(req.params.id), req.body);
        res.status(resultado.sucesso ? 200 : 400).json(resultado);
    } catch (error: any) {
        res.status(500).json({ sucesso: false, mensagem: error.message });
    }
}

export async function rejeitarSugestao(req: Request, res: Response) {
    try {
        const resultado = await sugestaoService.rejeitarSugestao(Number(req.params.id));
        res.status(resultado.sucesso ? 200 : 400).json(resultado);
    } catch (error: any) {
        res.status(500).json({ sucesso: false, mensagem: error.message });
    }
}