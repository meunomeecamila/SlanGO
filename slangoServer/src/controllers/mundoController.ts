import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware'; 
import {
    prepararRodadaAleatoria,
    listarMundos,
    listarMundosComProgresso,
    contarGiriasPorMundos,
    listarTodasGiriasComStatusDoMundo,
    listarGiriasAprendidasPorTodosMundos
} from '../services/mundoService';
import { salvarProgressoUsuario } from '../services/preogressoService';

export function getMundos(req: RequisicaoAutenticada, res: Response) {
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

export const getMundosComProgresso = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;
        const mundosComProgresso = await listarMundosComProgresso(idUsuario);

        res.status(200).json({
            sucesso: true,
            mundos: mundosComProgresso
        });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export const buscarMundo = async (req: RequisicaoAutenticada, res: Response) => {

    try {

        const { nome } = req.params as { nome: string };
        const idUsuario = req.usuario!.id!; // garantido pelo middleware `autenticar`

        const rodada = await prepararRodadaAleatoria(nome, idUsuario);

        res.status(200).json(rodada);

    } catch (e) {

        res.status(404).json({
            mensagem: "Mundo não encontrado"
        });

    }

};

export const getFasesDoMundo = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const nomeDoMundoRequisitado = req.params.nomeMundo as string;
        const idUsuario = req.usuario!.id!;

        const rodadaPronta = await prepararRodadaAleatoria(nomeDoMundoRequisitado, idUsuario);

        res.status(200).json(rodadaPronta);
    } catch (error: any) {
        res.status(404).json({ error: error.message });
    }
};

export function verificarPremioCustomizavel(pontuacaoFinal: number): boolean {
    const PONTUACAO_MAXIMA = 9; // 3 perguntas * 3 fases
    return pontuacaoFinal === PONTUACAO_MAXIMA;
}

export const validarResultadoJogo = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const { nomeDoMundo, girias, pontuacaoFinal } = req.body;
        const idUsuario = req.usuario!.id!;

        if (pontuacaoFinal === undefined) {
            return res.status(400).json({ error: "A pontuação final é obrigatória." });
        }

        if (!nomeDoMundo || !Array.isArray(girias) || girias.length === 0) {
            return res.status(400).json({
                error: "nomeDoMundo e girias (array com as gírias da rodada) são obrigatórios."
            });
        }

        const contagemMundos = contarGiriasPorMundos();
        const totalGiriasMundo = contagemMundos[nomeDoMundo] || 1;

        const ganhouPremio = verificarPremioCustomizavel(pontuacaoFinal);

        const { salvou, percentualAcerto, progressoMundo } = await salvarProgressoUsuario(
            nomeDoMundo,
            idUsuario,
            girias,
            pontuacaoFinal,
            totalGiriasMundo
        );

        res.status(200).json({
            sucesso: true,
            pontuacao: pontuacaoFinal,
            ganhouPremio: ganhouPremio,
            progressoSalvo: salvou,
            percentualAcerto,
            progressoMundo, 
            mensagem: ganhouPremio
                ? "🎉 Parabéns! Você fez 9/9 pontos! Item customizável LIBERADO!"
                : `❌ Poxa, você fez ${pontuacaoFinal} de 9 pontos. Tente novamente!`
        });

    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};


export const getGiriasAprendidasDoMundo = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const { nome } = req.params as { nome: string };
        const idUsuario = req.usuario!.id!;

        const girias = await listarTodasGiriasComStatusDoMundo(nome, idUsuario);

        res.status(200).json({
            sucesso: true,
            mundo: nome,
            quantidade: girias.length,
            girias
        });
    } catch (error: any) {
        res.status(404).json({ error: error.message });
    }
};

export const getGiriasAprendidasTodosMundos = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id!;

        const mundos = await listarGiriasAprendidasPorTodosMundos(idUsuario);

        res.status(200).json({
            sucesso: true,
            mundos
        });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export function contarGiriasPorMundo(req: RequisicaoAutenticada, res: Response) {
    try {
        const contagem = contarGiriasPorMundos();
        res.status(200).json(contagem);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};