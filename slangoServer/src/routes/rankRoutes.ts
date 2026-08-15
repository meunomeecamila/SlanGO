import { Router } from 'express';
import { autenticar } from '../middlewares/authMiddleware'; 
import { registrarRanking, getRankingDoMundo, getPosicaoDoUsuario } from '../controllers/rankController';

const router = Router();

router.post('/ranking/registrar', autenticar, registrarRanking);
router.get('/ranking/:nomeDoMundo', autenticar, getRankingDoMundo);
router.get('/ranking/:nomeDoMundo/posicao', autenticar, getPosicaoDoUsuario);

export default router;