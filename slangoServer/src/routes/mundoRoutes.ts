import { Router } from "express";
import {
    getFasesDoMundo,
    validarResultadoJogo,
    getMundos
} from "../controllers/mundoController";

const mundoRoutes = Router();

mundoRoutes.get("/mundos", getMundos);
mundoRoutes.get("/mundos/:nomeMundo/fases", getFasesDoMundo);
mundoRoutes.post("/mundos/resultado", validarResultadoJogo);

export default mundoRoutes;
