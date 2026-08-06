import { Router } from "express";
import { autenticar, bloquearConvidado } from '../middlewares/authMiddleware';
import {
    getMundos,
    getFasesDoMundo,
    validarResultadoJogo,
    getMundosComProgresso,
    buscarMundo,
    contarGiriasPorMundo
} from "../controllers/mundoController";

const mundoRoutes = Router();

mundoRoutes.get('/mundos', autenticar, getMundos);
mundoRoutes.get('/mundos/contagem', autenticar, contarGiriasPorMundo);
mundoRoutes.get('/mundos/progresso', autenticar, bloquearConvidado, getMundosComProgresso);
mundoRoutes.get('/mundos/:nome', autenticar, bloquearConvidado, buscarMundo);
mundoRoutes.get('/mundos/:nomeMundo/fases', autenticar, bloquearConvidado, getFasesDoMundo);
mundoRoutes.post('/mundos/resultado', autenticar, bloquearConvidado, validarResultadoJogo);

export default mundoRoutes;