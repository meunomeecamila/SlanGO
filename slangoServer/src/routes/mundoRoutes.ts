import { Router } from "express";
import {
    getFasesDoMundo,
    validarResultadoJogo,
    getMundos,
    buscarMundo
} from "../controllers/mundoController";

const mundoRoutes = Router();

mundoRoutes.get("/mundos", getMundos);
mundoRoutes.get("/mundos/:nome", buscarMundo);
mundoRoutes.get("/mundos/:nomeMundo/fases", getFasesDoMundo);
mundoRoutes.post("/mundos/resultado", validarResultadoJogo);

export default mundoRoutes;
