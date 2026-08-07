import { Router } from 'express';
import { criarSessaoConvidado } from '../controllers/authController';

const authRoutes = Router();

// Sem `autenticar` aqui — é justamente o endpoint que dá o token pra quem não tem nenhum.
authRoutes.post('/auth/convidado', criarSessaoConvidado);

export default authRoutes;