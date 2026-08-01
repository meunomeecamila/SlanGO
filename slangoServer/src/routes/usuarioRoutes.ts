import { Router } from "express";
import { autenticar } from "../middlewares/authMiddleware";
import {
    criarUsuarioController,
} from "../controllers/usuarioController";
import { login } from "../controllers/authController";

const usuarioRoutes = Router();

usuarioRoutes.post("/login", login);
usuarioRoutes.post("/cadastrar", criarUsuarioController);


export default usuarioRoutes;