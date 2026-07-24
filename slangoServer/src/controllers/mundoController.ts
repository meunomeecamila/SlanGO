import { Request, Response } from 'express';
import { prepararRodadaAleatoria } from '../services/mundoService';

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