import { Router } from 'express';
import { autenticar, bloquearConvidado } from '../middlewares/authMiddleware';
import {
    registrarRanking,
    getRankingGlobal,
    getMinhaPosicaoGlobal
} from '../controllers/rankController';

const router = Router();

router.post('/', autenticar, bloquearConvidado, registrarRanking);
router.get('/', autenticar, getRankingGlobal);
router.get('/minha-posicao', autenticar, getMinhaPosicaoGlobal);

export default router;