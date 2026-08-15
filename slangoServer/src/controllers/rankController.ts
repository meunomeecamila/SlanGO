import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware';
import { 
    registrarTempoRankeado, 
    buscarRankingDoMundo, 
    buscarPosicaoDoUsuario
} from '../services/rankService';
import { buscarIdMundoPorNome } from '../services/preogressoService';

export const registrarRanking = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const { nomeDoMundo, tempoMs, pontuacaoFinal } = req.body;
        const idUsuario = req.usuario!.id!;

        if (!nomeDoMundo || tempoMs === undefined || pontuacaoFinal === undefined) {
            return res.status(400).json({ error: 'nomeDoMundo, tempoMs e pontuacaoFinal são obrigatórios.' });
        }

        const idMundo = await buscarIdMundoPorNome(nomeDoMundo);
        if (idMundo === null) {
            return res.status(404).json({ error: 'Mundo não encontrado.' });
        }

        const resultado = await registrarTempoRankeado(idUsuario, idMundo, tempoMs, pontuacaoFinal);

        res.status(200).json({
            sucesso: true,
            ...resultado,
            mensagem: resultado.registrado
                ? '⏱️ Tempo registrado no ranking!'
                : `Você precisa de pelo menos 80% de acerto pra entrar no ranking (fez ${(resultado.percentualAcerto * 100).toFixed(0)}%).`,
        });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export const getRankingDoMundo = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const { nomeDoMundo } = req.params as { nomeDoMundo: string };
        const idMundo = await buscarIdMundoPorNome(nomeDoMundo);
        if (idMundo === null) return res.status(404).json({ error: 'Mundo não encontrado.' });

        const ranking = await buscarRankingDoMundo(idMundo);
        res.status(200).json({ sucesso: true, ranking });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export const getPosicaoDoUsuario = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const { nomeDoMundo } = req.params as { nomeDoMundo: string };
        const idUsuario = req.usuario!.id!;
        const idMundo = await buscarIdMundoPorNome(nomeDoMundo);
        if (idMundo === null) return res.status(404).json({ error: 'Mundo não encontrado.' });

        const posicao = await buscarPosicaoDoUsuario(idMundo, idUsuario);
        res.status(200).json({ sucesso: true, ...posicao });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};