import { Router } from "express";
import { autenticar } from '../middlewares/authMiddleware';
import {
    getFasesDoMundo,
    validarResultadoJogo,
    getMundosComProgresso,
    buscarMundo,
    contarGiriasPorMundo
} from "../controllers/mundoController";

const mundoRoutes = Router();

mundoRoutes.get('/mundos/progresso', autenticar, getMundosComProgresso); 
mundoRoutes.get('/mundos/contagem', autenticar, contarGiriasPorMundo);
mundoRoutes.get('/mundos/:nome', autenticar, buscarMundo);
mundoRoutes.get('/mundos/:nome', autenticar, buscarMundo);
mundoRoutes.get('/mundos/:nomeMundo/fases', autenticar, getFasesDoMundo);
mundoRoutes.post('/mundos/resultado', autenticar, validarResultadoJogo);

export default mundoRoutes;
