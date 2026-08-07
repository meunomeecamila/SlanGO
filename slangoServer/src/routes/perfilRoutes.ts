import { Router } from "express";
import { autenticar } from "../middlewares/authMiddleware";
import {
    listarItensController,
    equiparItemController,
} from "../controllers/itemController";
import {
    listarAstronautasController,
    atualizarAvatarController,
} from "../controllers/astronautaController";

const perfilRoutes = Router();

perfilRoutes.get("/astronautas", listarAstronautasController);
perfilRoutes.put("/perfil/avatar", autenticar, atualizarAvatarController);
perfilRoutes.get("/perfil/itens", autenticar, listarItensController);
perfilRoutes.put("/perfil/itens/:idItem/equipar", autenticar, equiparItemController);

export default perfilRoutes;
