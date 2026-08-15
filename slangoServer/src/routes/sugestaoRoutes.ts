import { Router } from 'express';
import { autenticar, exigeAdmin, bloquearConvidado } from '../middlewares/authMiddleware';
import {
    sugerirGiria,
    listarSugestoes,
    aprovarSugestao,
    rejeitarSugestao
} from '../controllers/sugestaoController';

const router = Router();

router.post('/girias/sugerir', autenticar, bloquearConvidado, sugerirGiria);
router.get('/girias/sugestoes', autenticar, exigeAdmin, bloquearConvidado, listarSugestoes);
router.post('/girias/sugestoes/:id/aprovar', autenticar, exigeAdmin, bloquearConvidado, aprovarSugestao);
router.post('/girias/sugestoes/:id/rejeitar', autenticar, exigeAdmin, bloquearConvidado, rejeitarSugestao);

export default router;