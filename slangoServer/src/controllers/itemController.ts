import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware';
import { listarItensDoUsuario, equiparItem } from '../services/itemService';

export const listarItensController = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const itens = await listarItensDoUsuario(idUsuario);
        res.status(200).json({ sucesso: true, itens });
    } catch (error: any) {
        res.status(500).json({ erro: error.message });
    }
};

export const equiparItemController = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const { idItem } = req.params;

        await equiparItem(idUsuario, Number(idItem));

        res.status(200).json({ sucesso: true, mensagem: 'Item equipado com sucesso.' });
    } catch (error: any) {
        if (error.message === 'ITEM_NAO_DESBLOQUEADO') {
            return res.status(403).json({ erro: 'Você ainda não desbloqueou esse item.' });
        }
        res.status(500).json({ erro: error.message });
    }
};