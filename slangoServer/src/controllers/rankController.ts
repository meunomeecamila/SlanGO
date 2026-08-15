import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware';
import { 
    registrarTempoRankeado, 
    buscarRankingGlobal, 
    buscarPosicaoGlobalDoUsuario
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
                ? '🏆 Tempo perfeito registrado no ranking!'
                : 'Só entra no ranking quem acerta todas as questões. Tente de novo!',
        });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export const getRankingGlobal = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const limite = req.query.limite ? Number(req.query.limite) : 500;
        const ranking = await buscarRankingGlobal(limite);
        res.status(200).json({ sucesso: true, ranking });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export const getMinhaPosicaoGlobal = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const posicao = await buscarPosicaoGlobalDoUsuario(idUsuario);
        res.status(200).json({ sucesso: true, ...posicao });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};