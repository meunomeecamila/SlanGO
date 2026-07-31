import { Router } from "express";
import {
    getFasesDoMundo,
    validarResultadoJogo,
    getMundos,
    buscarMundo,
    contarGiriasPorMundo
} from "../controllers/mundoController";

const mundoRoutes = Router();

mundoRoutes.get("/mundos", getMundos);
mundoRoutes.get("/mundos/contagem", contarGiriasPorMundo);
mundoRoutes.get("/mundos/:nomeMundo/fases", getFasesDoMundo);
mundoRoutes.get("/mundos/:nome", buscarMundo);
mundoRoutes.post("/mundos/resultado", validarResultadoJogo);

export default mundoRoutes;
