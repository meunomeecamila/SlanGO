import { Router } from 'express';
import { autenticar, bloquearConvidado } from '../middlewares/authMiddleware';
import {
    enviarSugestao,
    historicoDoUsuario,
    listarPendentes,
    moderar,
    historicoModeradas,
    excluirSugestao,
} from '../controllers/sugestaoController';

const router = Router();

// Todas as rotas exigem usuário logado (convidados não participam).
router.use(autenticar, bloquearConvidado);

// Usuário comum: enviar sugestão + acompanhar histórico
router.post('/sugestoes', enviarSugestao);
router.get('/sugestoes/minhas', historicoDoUsuario);

// Admin: fila de moderação + ação de aceitar/recusar
router.get('/sugestoes/pendentes', listarPendentes);
router.patch('/sugestoes/:id/moderar', moderar);

// Admin: histórico de moderação + exclusão
router.get('/sugestoes/historico-moderadas', historicoModeradas);
router.delete('/sugestoes/:id', excluirSugestao);

export default router;