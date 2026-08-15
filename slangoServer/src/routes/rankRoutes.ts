import { Router } from 'express';
import { autenticar, bloquearConvidado } from '../middlewares/authMiddleware';
import {
    registrarRanking,
    getRankingGlobal,
    getMinhaPosicaoGlobal
} from '../controllers/rankController';

const router = Router();

router.post('/ranking', autenticar, bloquearConvidado, registrarRanking);
router.get('/ranking', autenticar, getRankingGlobal);
router.get('/ranking/minha-posicao', autenticar, getMinhaPosicaoGlobal);

export default router;