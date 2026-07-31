import { Request, Response } from 'express';
import { 
    prepararRodadaAleatoria,
    listarMundos,
    contarGiriasPorMundos
} from '../services/mundoService';
import {  } from "../services/mundoService";

export function getMundos(req: Request, res: Response) {
    try {
        const mundos = listarMundos();

        res.status(200).json({
            sucesso: true,
            mundos
        });

    } catch (error: any) {
        res.status(500).json({
            erro: error.message
        });
    }
}

export const buscarMundo = async (req: Request, res: Response) => {

    try {

        const { nome } = req.params as { nome: string};

        const rodada = await prepararRodadaAleatoria(nome);

        res.status(200).json(rodada);

    } catch (e) {

        res.status(404).json({
            mensagem: "Mundo não encontrado"
        });

    }

};

export const getFasesDoMundo = async (req: Request, res: Response) => {
    try {
        const nomeDoMundoRequisitado = req.params.nomeMundo as string;

        const rodadaPronta = await prepararRodadaAleatoria(nomeDoMundoRequisitado);
        
        res.status(200).json(rodadaPronta);
    } catch (error: any) {
        res.status(404).json({ error: error.message });
    }
};

export function verificarPremioCustomizavel(pontuacaoFinal: number): boolean {
    const PONTUACAO_MAXIMA = 9; // 3 perguntas * 3 fases
    return pontuacaoFinal === PONTUACAO_MAXIMA;
}

export const validarResultadoJogo = (req: Request, res: Response) => {
    try {
        const pontuacaoFinal = req.body.pontuacaoFinal as number;

        if (pontuacaoFinal === undefined) {
            return res.status(400).json({ error: "A pontuação final é obrigatória." });
        }
        
        const ganhouPremio = verificarPremioCustomizavel(pontuacaoFinal);

        // Devolve o veredito para o celular
        res.status(200).json({
            sucesso: true,
            pontuacao: pontuacaoFinal,
            ganhouPremio: ganhouPremio,
            mensagem: ganhouPremio 
                ? "🎉 Parabéns! Você fez 9/9 pontos! Item customizável LIBERADO!" 
                : `❌ Poxa, você fez ${pontuacaoFinal} de 9 pontos. Tente novamente!`
        });

    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export function contarGiriasPorMundo(req: Request, res: Response) {
    try {
        const contagem = contarGiriasPorMundos();
        res.status(200).json(contagem);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }   
};