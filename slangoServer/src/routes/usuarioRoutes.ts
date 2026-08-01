import { Router } from "express";
import { autenticar } from "../middlewares/authMiddleware";
import {
    criarUsuarioController,
} from "../controllers/usuarioController";

const usuarioRoutes = Router();

//usuarioRoutes.post("/login", login);
usuarioRoutes.post("/cadastrar", criarUsuarioController);


export default usuarioRoutes;