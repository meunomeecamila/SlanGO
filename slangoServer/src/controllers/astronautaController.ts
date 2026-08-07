import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware';
import { listarAstronautas, atualizarAvatarUsuario } from '../services/astronautaService';

export const listarAstronautasController = async (_req: RequisicaoAutenticada, res: Response) => {
    try {
        const astronautas = await listarAstronautas();
        res.status(200).json({ sucesso: true, astronautas });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export const atualizarAvatarController = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const { idAstronauta } = req.body;

        if (!idAstronauta) {
            return res.status(400).json({ erro: 'idAstronauta é obrigatório.' });
        }

        await atualizarAvatarUsuario(idUsuario, Number(idAstronauta));
        res.status(200).json({ sucesso: true, mensagem: 'Avatar atualizado com sucesso.' });
    } catch (error: any) {
        if (error.message === 'ASTRONAUTA_INVALIDO') {
            return res.status(400).json({ erro: 'Astronauta inválido.' });
        }
        res.status(500).json({ erro: error.message });
    }
};