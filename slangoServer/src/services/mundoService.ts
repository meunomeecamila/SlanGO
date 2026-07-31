import antigoData from '../utils/girias/antigo.json';
import cotidianoData from '../utils/girias/cotidiano.json';
import esportesData from '../utils/girias/esportes.json';
import geekData from '../utils/girias/geek.json';
import jogosData from '../utils/girias/jogos.json';
import kpopData from '../utils/girias/kpop.json';
import maquiagemData from '../utils/girias/maquiagem.json';
import outrosData from '../utils/girias/outros.json';
import popData from '../utils/girias/pop.json';
import redesSociaisData from '../utils/girias/redessociais.json';
import relacionamentosData from '../utils/girias/relacionamentos.json';

import { Girias, FaseMundo } from '../types/Jogo';

const mundos = {
    antigo: antigoData,
    cotidiano: cotidianoData,
    esportes: esportesData,
    geek: geekData,
    jogos: jogosData,
    kpop: kpopData,
    maquiagem: maquiagemData,
    outros: outrosData,
    pop: popData,
    redessociais: redesSociaisData,
    relacionamentos: relacionamentosData,
};

interface EstadoMundo {
    listaEmbaralhada: Girias[];
    indiceAtual: number;
}

const estadoDosMundos: Record<string, EstadoMundo> = {};

// ──────────────────────────────────────────────────────────────
// 1. FUNÇÕES AUXILIARES DE EMBARALHAMENTO
// ──────────────────────────────────────────────────────────────

/** Algoritmo de Fisher-Yates: matematicamente perfeito para embaralhar */
function fisherYatesShuffle<T>(array: T[]): T[] {
    const arr = [...array];
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
}

/** Embaralha as alternativas da pergunta usando Fisher-Yates */
function embaralharOpcoes(opcoes: string[]): string[] {
    return fisherYatesShuffle(opcoes);
}

/**
 * Sorteia `quantidade` gírias únicas do pool total.
 */
function puxarProximasGiriasUnicas(nomeDoMundo: string, todasAsGirias: Girias[], quantidade: number): Girias[] {
    if (!estadoDosMundos[nomeDoMundo]) {
        estadoDosMundos[nomeDoMundo] = {
            listaEmbaralhada: fisherYatesShuffle(todasAsGirias),
            indiceAtual: 0
        };
    }

    const estado = estadoDosMundos[nomeDoMundo];

    // Se as cartas acabarem, embaralha o deck inteiro de novo
    if (estado.indiceAtual + quantidade > estado.listaEmbaralhada.length) {
        console.log(`🔄 Fim do baralho no mundo '${nomeDoMundo}'. Embaralhando novamente!`);
        estado.listaEmbaralhada = fisherYatesShuffle(todasAsGirias);
        estado.indiceAtual = 0;
    }

    const inicio = estado.indiceAtual;
    const fim = estado.indiceAtual + quantidade;
    const itensSorteados = estado.listaEmbaralhada.slice(inicio, fim);

    estado.indiceAtual = fim;
    return itensSorteados;
}

// ──────────────────────────────────────────────────────────────
// 2. GERADORES DE FASES
// Cada fase testa um aspecto diferente das mesmas 3 gírias:
//   Fase 1 → Significado  (o que a gíria quer dizer?)
//   Fase 2 → Impacto      (qual sentimento ela passa?)
//   Fase 3 → Uso correto  (qual frase usa a gíria certo?)
// ──────────────────────────────────────────────────────────────

function gerarFase1(giriasSorteadas: Girias[]) {
    return giriasSorteadas.map((giria) => {
        const todasAsOpcoes = [giria.significado, ...giria.significados_incorretos];
        return {
            giria: giria.nome,
            textoDaPergunta: `Qual é o significado correto da gíria "${giria.nome}"?`,
            opcoes: embaralharOpcoes(todasAsOpcoes),
            respostaCorreta: giria.significado,
            explicacao: giria.significado, // Preserva o significado real da gíria
        };
    });
}

function gerarFase2(giriasSorteadas: Girias[]) {
    const opcoesDeImpacto = ['positiva', 'negativa', 'neutra', 'depende de contexto'];
    return giriasSorteadas.map((giria) => {
        return {
            giria: giria.nome,
            textoDaPergunta: `Qual é o impacto/sentimento que a gíria "${giria.nome}" passa?`,
            opcoes: opcoesDeImpacto, // Não embaralha para manter padrão dos botões
            respostaCorreta: giria.impacto,
            explicacao: giria.significado, // Preserva o significado real para contexto
        };
    });
}

function gerarFase3(giriasSorteadas: Girias[]) {
    return giriasSorteadas.map((giria) => {
        const todasAsFrases = [giria.exemplo_correto, ...giria.exemplos_incorretos];
        return {
            giria: giria.nome,
            textoDaPergunta: `Qual é a aplicação correta da gíria "${giria.nome}" em uma frase?`,
            opcoes: embaralharOpcoes(todasAsFrases),
            respostaCorreta: giria.exemplo_correto,
            explicacao: giria.significado, // Preserva o significado real para contexto
        };
    });
}

// ──────────────────────────────────────────────────────────────
// 3. HELPER: converter pergunta interna → FaseMundo
// ──────────────────────────────────────────────────────────────
interface PerguntaInterna {
    giria: string;
    textoDaPergunta: string;
    opcoes: string[];
    respostaCorreta: string;
    explicacao: string;
}

function converterParaFaseMundo(
    pergunta: PerguntaInterna,
    id: number,
    variacoes: string[]
): FaseMundo & { respostaCorreta: string } {
    return {
        id,
        giria: pergunta.giria,
        variacoes,
        pergunta: pergunta.textoDaPergunta,
        explicacao: pergunta.explicacao,
        respostaCorreta: pergunta.respostaCorreta, // Exportado explicitamente para o Gabarito Final
        alternativas: pergunta.opcoes.map((opcao) => ({
            texto: opcao,
            correta: opcao === pergunta.respostaCorreta,
        })),
    };
}

// ──────────────────────────────────────────────────────────────
// 4. FUNÇÃO PRINCIPAL: prepararRodadaAleatoria
// ──────────────────────────────────────────────────────────────
export const prepararRodadaAleatoria = async (nomeDoMundo: string) => {
    const mundo = mundos[nomeDoMundo as keyof typeof mundos];

    if (!mundo) {
        throw new Error('Mundo não encontrado!');
    }

    const chave = Object.keys(mundo)[0];
    const todasAsGiriasDoMundo = (mundo as any)[chave] as Girias[];

    const tituloDoMundo =
        `Mundo ${nomeDoMundo.charAt(0).toUpperCase()}${nomeDoMundo.slice(1)}`;

    const descricaoDoMundo =
        `Aprenda as gírias de ${nomeDoMundo}`;

    // Sorteia 3 gírias únicas usando o nosso "Baralho" dinâmico
    const tresPalavras = puxarProximasGiriasUnicas(nomeDoMundo, todasAsGiriasDoMundo, 3);

    // Gera as perguntas das 3 fases sobre as mesmas 3 gírias
    const fase1 = gerarFase1(tresPalavras); // 3 perguntas de significado
    const fase2 = gerarFase2(tresPalavras); // 3 perguntas de impacto
    const fase3 = gerarFase3(tresPalavras); // 3 perguntas de uso correto

    // Mapa de variações por nome de gíria — para usar nas conversões
    const variacoesPorGiria: Record<string, string[]> = {};
    tresPalavras.forEach((g) => { variacoesPorGiria[g.nome] = g.variacoes || []; });

    // ── fases: as 3 gírias para a Tela de Estudo ──
    const fases = tresPalavras.map((giria, index) =>
        converterParaFaseMundo(fase1[index], index + 1, giria.variacoes || [])
    );

    // ── todasAsPerguntas: as 9 perguntas do quiz em sequência ──
    const todasAsPerguntas = [
        ...fase1.map((q, i) => converterParaFaseMundo(q, i + 1, variacoesPorGiria[q.giria] ?? [])),
        ...fase2.map((q, i) => converterParaFaseMundo(q, 3 + i + 1, variacoesPorGiria[q.giria] ?? [])),
        ...fase3.map((q, i) => converterParaFaseMundo(q, 6 + i + 1, variacoesPorGiria[q.giria] ?? [])),
    ];

    return {
        id: nomeDoMundo,
        nome: tituloDoMundo,
        descricao: descricaoDoMundo,
        fases,            // 3 itens — para a Tela de Estudo
        todasAsPerguntas, // 9 itens — com gabarito completo para a Tela Final
        quiz: { fase1, fase2, fase3 },
    };
};

/** Verifica se o jogador fez pontuação máxima (9/9) */
export function verificarPremioCustomizavel(pontuacaoFinal: number): boolean {
    const PONTUACAO_MAXIMA = 9; // 3 gírias × 3 fases = 9 perguntas
    return pontuacaoFinal === PONTUACAO_MAXIMA;
}

export function listarMundos() {
    return Object.keys(mundos).map((nome) => {
        return nome.charAt(0).toUpperCase() + nome.slice(1);
    });
}


export function contarGiriasPorMundos(): Record<string, number> {
    return Object.entries(mundos).reduce((acumulador, [nome, mundoData]) => {
        const chaves = Object.keys(mundoData);
        const girias = chaves.length > 0 ? (mundoData as any)[chaves[0]] : [];

        acumulador[nome] = Array.isArray(girias) ? girias.length : 0;

        return acumulador;
    }, {} as Record<string, number>);
}