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
import { obterIdiomaDoUsuario } from '../services/usuarioService';
import {
    IDIOMAS_SUPORTADOS,
    idiomaValido,
} from '../utils/girias/dicionarioGirias';

async function idiomaDaRequisicao(req: RequisicaoAutenticada): Promise<string> {
    const solicitado = typeof req.query.idioma === 'string'
        ? req.query.idioma.toLowerCase()
        : '';
    if (idiomaValido(solicitado)) return solicitado;
    if (req.usuario?.id) return obterIdiomaDoUsuario(req.usuario.id);
    return IDIOMAS_SUPORTADOS[0];
}

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
        const idUsuario = req.usuario?.id ?? null;
        const idioma = await idiomaDaRequisicao(req);
        const mundosComProgresso = await listarMundosComProgresso(idUsuario, idioma);

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
        const idUsuario = req.usuario?.id ?? null;
        const idioma = await idiomaDaRequisicao(req);

        const rodada = await prepararRodadaAleatoria(nome, idUsuario, idioma);

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
        const idioma = await idiomaDaRequisicao(req);

        const rodadaPronta = await prepararRodadaAleatoria(nomeDoMundoRequisitado, idUsuario, idioma);

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
        const idioma = await idiomaDaRequisicao(req);

        if (pontuacaoFinal === undefined) {
            return res.status(400).json({ error: "A pontuação final é obrigatória." });
        }

        if (!nomeDoMundo || !Array.isArray(girias) || girias.length === 0) {
            return res.status(400).json({
                error: "nomeDoMundo e girias (array com as gírias da rodada) são obrigatórios."
            });
        }

        const ganhouPremio = verificarPremioCustomizavel(pontuacaoFinal);

        const { salvou, percentualAcerto, progressoMundo } = await salvarProgressoUsuario(
            nomeDoMundo,
            idUsuario,
            girias,
            pontuacaoFinal,
            idioma
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
        const idioma = await idiomaDaRequisicao(req);

        const girias = await listarTodasGiriasComStatusDoMundo(nome, idUsuario, idioma);

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
        const idioma = await idiomaDaRequisicao(req);

        const mundos = await listarGiriasAprendidasPorTodosMundos(idUsuario, idioma);

        res.status(200).json({
            sucesso: true,
            mundos
        });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

export async function contarGiriasPorMundo(req: RequisicaoAutenticada, res: Response) {
    try {
        const idioma = await idiomaDaRequisicao(req);
        const contagem = contarGiriasPorMundos(idioma);
        res.status(200).json(contagem);
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};