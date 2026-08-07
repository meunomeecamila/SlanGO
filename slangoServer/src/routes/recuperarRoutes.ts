import { Router } from 'express';
import {
    obterPerguntaSeguranca,
    recuperarSenhaController,
} from '../controllers/senhaController';

const recuperarSenhaRoutes = Router();

recuperarSenhaRoutes.get('/recuperar-senha/pergunta', obterPerguntaSeguranca);
recuperarSenhaRoutes.post('/recuperar-senha', recuperarSenhaController);

export default recuperarSenhaRoutes;