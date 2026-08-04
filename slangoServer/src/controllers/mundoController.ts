import { Response } from 'express';
import { RequisicaoAutenticada } from '../middlewares/authMiddleware'; // ⚠️ ajuste o caminho conforme sua estrutura
import {
    prepararRodadaAleatoria,
    listarMundos,
    listarMundosComProgresso,
    contarGiriasPorMundos
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

// GET /mundos/progresso — precisa vir ANTES de /mundos/:nome nas rotas,
// senão o Express vai tentar casar "progresso" como se fosse o :nome de um mundo.
// Precisa passar pelo middleware `autenticar`.
export const getMundosComProgresso = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const idUsuario = req.usuario!.id;
        const mundosComProgresso = await listarMundosComProgresso(idUsuario);

        res.status(200).json({
            sucesso: true,
            mundos: mundosComProgresso
        });
    } catch (error: any) {
        res.status(500).json({ error: error.message });
    }
};

// Rota volta a ser GET /mundos/:nome — idUsuario vem do token, não da URL.
// Precisa passar pelo middleware `autenticar` na definição da rota.
export const buscarMundo = async (req: RequisicaoAutenticada, res: Response) => {

    try {

        const { nome } = req.params as { nome: string };
        const idUsuario = req.usuario!.id; // garantido pelo middleware `autenticar`

        const rodada = await prepararRodadaAleatoria(nome, idUsuario);

        res.status(200).json(rodada);

    } catch (e) {

        res.status(404).json({
            mensagem: "Mundo não encontrado"
        });

    }

};

// Rota volta a ser GET /mundos/:nomeMundo/fases — idUsuario vem do token.
// Precisa passar pelo middleware `autenticar` na definição da rota.
export const getFasesDoMundo = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const nomeDoMundoRequisitado = req.params.nomeMundo as string;
        const idUsuario = req.usuario!.id;

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

// POST /mundos/resultado — precisa passar pelo middleware `autenticar`.
// Body esperado agora: { nomeDoMundo, girias: string[3], pontuacaoFinal }
// (idUsuario NÃO vem mais no body — vem do token, evita que alguém salve progresso em nome de outro usuário)
export const validarResultadoJogo = async (req: RequisicaoAutenticada, res: Response) => {
    try {
        const { nomeDoMundo, girias, pontuacaoFinal } = req.body;
        const idUsuario = req.usuario!.id;

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

        // Salva o progresso do usuário (só grava de fato se acerto >= 80%)
        const { salvou, percentualAcerto } = await salvarProgressoUsuario(
            nomeDoMundo,
            idUsuario,
            girias,
            pontuacaoFinal,
            totalGiriasMundo
        );

        // Devolve o veredito para o celular
        res.status(200).json({
            sucesso: true,
            pontuacao: pontuacaoFinal,
            ganhouPremio: ganhouPremio,
            progressoSalvo: salvou,
            percentualAcerto,
            mensagem: ganhouPremio
                ? "🎉 Parabéns! Você fez 9/9 pontos! Item customizável LIBERADO!"
                : `❌ Poxa, você fez ${pontuacaoFinal} de 9 pontos. Tente novamente!`
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