import { Router } from "express";
import { autenticar } from "../middlewares/authMiddleware";
import {
    criarUsuarioController,
    buscarUsuarioController,
    atualizarUsuarioController,
    deletarUsuarioController
} from "../controllers/usuarioController";
import { login } from "../controllers/authController";

const usuarioRoutes = Router();

usuarioRoutes.post("/login", login);
usuarioRoutes.post("/cadastrar", criarUsuarioController);
usuarioRoutes.get("/usuario/:id", autenticar, buscarUsuarioController);
usuarioRoutes.put("/usuario/:id", autenticar, atualizarUsuarioController);
usuarioRoutes.delete("/usuario/:id", autenticar, deletarUsuarioController);

export default usuarioRoutes;