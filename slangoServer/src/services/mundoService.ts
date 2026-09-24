import { Girias, FaseMundo } from '../types/Jogo';
import {
    buscarGiriasAprendidas,
    buscarIdMundoPorNome,
    buscarProgressoDoUsuario,
    buscarProgressoMaximoPorMundo,
} from './preogressoService';
import {
    contarGiriasPorMundos as contarGiriasDoDicionario,
    idiomaValido,
    NOMES_MUNDOS,
    obterGiriasDoMundo,
} from '../utils/girias/dicionarioGirias';

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
 * Sorteia `quantidade` gírias únicas do pool total, para um usuário e mundo específicos.
 * Gírias em `giriasParaExcluir` (já aprendidas pelo usuário, ≥80% em rodada anterior)
 * ficam de fora do sorteio, até acabarem — aí libera o pool completo de novo (revisão).
 */
function puxarProximasGiriasUnicas(
    chaveEstado: string,
    todasAsGirias: Girias[],
    quantidade: number,
    giriasParaExcluir: any[] = [] // Aceita array de IDs (números ou strings)
): Girias[] {
    const idsParaExcluirNormalizados = giriasParaExcluir.map(String);
    let poolDisponivel = todasAsGirias.filter(
        (g) => !idsParaExcluirNormalizados.includes(String(g.id))
    );

    // Se o usuário já aprendeu quase tudo (ou tudo) do mundo, libera o pool completo
    // pra ele poder continuar jogando em modo revisão, em vez de travar o sorteio.
    if (poolDisponivel.length < quantidade) {
        console.log(`🎓 Usuário quase dominou este mundo. Liberando pool completo para revisão.`);
        poolDisponivel = todasAsGirias;
    }

    if (!estadoDosMundos[chaveEstado]) {
        estadoDosMundos[chaveEstado] = {
            listaEmbaralhada: fisherYatesShuffle(poolDisponivel),
            indiceAtual: 0
        };
    }

    const estado = estadoDosMundos[chaveEstado];

    // Se as cartas acabarem, embaralha o deck inteiro de novo (respeitando exclusões)
    if (estado.indiceAtual + quantidade > estado.listaEmbaralhada.length) {
        console.log(`🔄 Fim do baralho em '${chaveEstado}'. Embaralhando novamente!`);
        estado.listaEmbaralhada = fisherYatesShuffle(poolDisponivel);
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
            giriaId: giria.id, // 🔥 MUDANÇA: Adicionado o ID da gíria
            tipo: 'significado' as const,
            giria: giria.nome,
            textoDaPergunta: `Qual é o significado correto da gíria "${giria.nome}"?`,
            opcoes: embaralharOpcoes(todasAsOpcoes),
            respostaCorreta: giria.significado,
            explicacao: giria.significado,
            exemplo: giria.exemplo_correto,
            impactoMotivo: giria.impacto_motivo ?? '',
        };
    });
}

type CategoriaImpacto = 'positiva' | 'negativa' | 'neutra' | 'depende';

const ROTULOS_IMPACTO: Record<string, Record<CategoriaImpacto, string>> = {
    pt: { positiva: 'positiva', negativa: 'negativa', neutra: 'neutra', depende: 'depende de contexto' },
    en: { positiva: 'positive', negativa: 'negative', neutra: 'neutral', depende: 'depends on context' },
    es: { positiva: 'positiva', negativa: 'negativa', neutra: 'neutra', depende: 'depende del contexto' },
    it: { positiva: 'positiva', negativa: 'negativa', neutra: 'neutra', depende: 'dipende dal contesto' },
};

/** Converte "positive", "positivo", "depende del contexto", etc. para uma categoria única. */
function categoriaDoImpacto(impacto: string): CategoriaImpacto {
    const v = (impacto ?? '').trim().toLowerCase();
    if (v.startsWith('posit')) return 'positiva';
    if (v.startsWith('negat')) return 'negativa';
    if (v.startsWith('neut')) return 'neutra';
    return 'depende';
}

function gerarFase2(giriasSorteadas: Girias[], idioma = 'pt') {
    const rotulos = ROTULOS_IMPACTO[idioma] ?? ROTULOS_IMPACTO.pt;
    const opcoesDeImpacto = [rotulos.positiva, rotulos.negativa, rotulos.neutra, rotulos.depende];
    return giriasSorteadas.map((giria) => {
        return {
            giriaId: giria.id, 
            tipo: 'impacto' as const,
            giria: giria.nome,
            textoDaPergunta: `Qual é o impacto/sentimento que a gíria "${giria.nome}" passa?`,
            opcoes: opcoesDeImpacto,
            // Sempre um dos rótulos das opções — garante uma alternativa correta.
            respostaCorreta: rotulos[categoriaDoImpacto(giria.impacto)],
            explicacao: giria.significado,
            exemplo: giria.exemplo_correto,
            // Justificativa exibida na caixinha logo abaixo da alternativa correta
            impactoMotivo: giria.impacto_motivo ?? '',
        };
    });
}

function gerarFase3(giriasSorteadas: Girias[]) {
    return giriasSorteadas.map((giria) => {
        const todasAsFrases = [giria.exemplo_correto, ...giria.exemplos_incorretos];
        return {
            giriaId: giria.id, 
            tipo: 'aplicacao' as const,
            giria: giria.nome,
            textoDaPergunta: `Qual é a aplicação correta da gíria "${giria.nome}" em uma frase?`,
            opcoes: embaralharOpcoes(todasAsFrases),
            respostaCorreta: giria.exemplo_correto,
            explicacao: giria.significado,
            exemplo: giria.exemplo_correto,
            impactoMotivo: giria.impacto_motivo ?? '',
        };
    });
}

// ──────────────────────────────────────────────────────────────
// 3. HELPER: converter pergunta interna → FaseMundo
// ──────────────────────────────────────────────────────────────
interface PerguntaInterna {
    giriaId: number | string; 
    tipo?: string;
    giria: string;
    textoDaPergunta: string;
    opcoes: string[];
    respostaCorreta: string;
    explicacao: string;
    impactoMotivo?: string;
}

function converterParaFaseMundo(
    pergunta: PerguntaInterna,
    id: number,
    variacoes: string[],
    exemplo: string,
    classe?: string
): FaseMundo & {
    respostaCorreta: string;
    exemplo: string;
    classe?: string;
    giriaId: number | string;
    tipo: string;
    impactoMotivo: string;
} {
    return {
        id, // Este é o ID da pergunta no quiz (1 a 9)
        giriaId: pergunta.giriaId, 
        tipo: pergunta.tipo ?? 'significado',
        giria: pergunta.giria,
        variacoes,
        pergunta: pergunta.textoDaPergunta,
        explicacao: pergunta.explicacao,
        respostaCorreta: pergunta.respostaCorreta,
        impactoMotivo: pergunta.impactoMotivo ?? '',
        exemplo,
        classe,
        alternativas: pergunta.opcoes.map((opcao) => ({
            texto: opcao,
            correta: opcao === pergunta.respostaCorreta,
        })),
    };
}

// ──────────────────────────────────────────────────────────────
// 4. FUNÇÃO PRINCIPAL: prepararRodadaAleatoria
// ──────────────────────────────────────────────────────────────
export const prepararRodadaAleatoria = async (
    nomeDoMundo: string,
    idUsuario: number | null,
    idioma = 'pt',
) => {
    const mundo = nomeDoMundo.trim().toLowerCase();

    if (!NOMES_MUNDOS.includes(mundo as (typeof NOMES_MUNDOS)[number])) {
        throw new Error('Mundo não encontrado!');
    }

    const todasAsGiriasDoMundo = obterGiriasDoMundo(mundo, idioma);

    const tituloDoMundo =
        `Mundo ${nomeDoMundo.charAt(0).toUpperCase()}${nomeDoMundo.slice(1)}`;

    const descricaoDoMundo =
        `Aprenda as gírias de ${nomeDoMundo}`;

    // Busca no banco quais gírias (IDs) esse usuário já aprendeu.
    const idMundoNumerico = await buscarIdMundoPorNome(nomeDoMundo);
    const giriasJaAprendidas = idMundoNumerico !== null && idUsuario !== null
        ? await buscarGiriasAprendidas(idMundoNumerico, idUsuario, idioma)
        : [];

    // A partir de 10% de gírias aprendidas nesse mundo, elas voltam a
    // entrar no sorteio normal (chance de reaparecer como revisão), em vez
    // de ficarem sempre excluídas. Abaixo de 10%, mantém o comportamento
    // atual (foco total em gírias novas).
    const totalGiriasDoMundo = todasAsGiriasDoMundo.length;
    const percentualAprendido = totalGiriasDoMundo > 0
        ? giriasJaAprendidas.length / totalGiriasDoMundo
        : 0;

    const giriasParaExcluir = percentualAprendido >= 0.10 ? [] : giriasJaAprendidas;

    // Sorteia 3 gírias únicas
    const chaveEstado = `${idUsuario ?? 'convidado'}_${mundo}_${idioma}`;
    const tresPalavras = puxarProximasGiriasUnicas(
        chaveEstado,
        todasAsGiriasDoMundo,
        3,
        giriasParaExcluir // Vazio a partir de 10% aprendido, senão os IDs já aprendidos
    );

    // Gera as perguntas das 3 fases sobre as mesmas 3 gírias
    const fase1 = gerarFase1(tresPalavras);
    const fase2 = gerarFase2(tresPalavras, idioma);
    const fase3 = gerarFase3(tresPalavras);

    const variacoesPorGiria: Record<string, string[]> = {};
    tresPalavras.forEach((g) => { variacoesPorGiria[g.nome] = g.variacoes || []; });

    // ── fases: as 3 gírias para a Tela de Estudo ──
    const fases = tresPalavras.map((giria, index) =>
        converterParaFaseMundo(
            fase1[index],
            index + 1,
            giria.variacoes || [],
            giria.exemplo_correto,
            giria.classe_gramatical ?? (giria as any).classe
        )
    );

    // ── todasAsPerguntas: as 9 perguntas do quiz AGRUPADAS POR GÍRIA ──
    // Ordem: Gíria 1 (significado → impacto → aplicação), Gíria 2 (...), Gíria 3 (...)
    const todasAsPerguntas = tresPalavras.flatMap((giria, index) => {
        const base = index * 3;
        return [fase1[index], fase2[index], fase3[index]].map((q, offset) =>
            converterParaFaseMundo(
                q,
                base + offset + 1,
                variacoesPorGiria[q.giria] ?? [],
                q.exemplo || '',
                (giria as any).classe_gramatical
            )
        );
    });

    return {
        id: mundo,
        nome: tituloDoMundo,
        descricao: descricaoDoMundo,
        fases,            
        todasAsPerguntas, 
        quiz: { fase1, fase2, fase3 },
    };
};

/** Verifica se o jogador fez pontuação máxima (9/9) */
export function verificarPremioCustomizavel(pontuacaoFinal: number): boolean {
    const PONTUACAO_MAXIMA = 9; // 3 gírias × 3 fases = 9 perguntas
    return pontuacaoFinal === PONTUACAO_MAXIMA;
}

export function listarMundos() {
    return [...NOMES_MUNDOS].map((nome) => {
        return nome.charAt(0).toUpperCase() + nome.slice(1);
    });
}

/**
 * Retorna, para cada mundo conhecido no código (as chaves de `mundos`),
 * o progresso real do usuário logado (0 se ele nunca jogou aquele mundo ainda).
 * Usado pelo endpoint GET /mundos/progresso, que substitui os valores
 * hardcoded de `progresso` na lista estática do Flutter.
 */
export async function listarMundosComProgresso(
    idUsuario: number | null,
    idioma = 'pt',
): Promise<Array<{
    id: string;
    progresso: number;
    quantidadeAprendida: number;
    totalGirias: number;
    progressoMaximo: number;
    diplomaDesbloqueado: boolean;
}>> {
    const nomesDosMundos = [...NOMES_MUNDOS];
    const contagemMundos = contarGiriasPorMundos(idioma);

    // Diploma é conquista permanente: vale o melhor progresso já feito em
    // qualquer idioma, então trocar o idioma nunca remove um diploma.
    const progressoMaximoPorMundo = idUsuario !== null
        ? await buscarProgressoMaximoPorMundo(idUsuario)
        : {};

    const resultados = await Promise.all(
        nomesDosMundos.map(async (nome) => {
            const idMundo = await buscarIdMundoPorNome(nome);
            const totalGirias = contagemMundos[nome] ?? 0;

            if (idMundo === null || idUsuario === null) {
                // Mundo existe no código mas ainda não foi cadastrado na tabela `Mundo`
                return {
                    id: nome,
                    progresso: 0,
                    quantidadeAprendida: 0,
                    totalGirias,
                    progressoMaximo: 0,
                    diplomaDesbloqueado: false,
                };
            }

            const { progresso, quantidadeAprendida } = await buscarProgressoDoUsuario(idMundo, idUsuario, idioma);
            const progressoMaximo = Math.max(progresso, progressoMaximoPorMundo[idMundo] ?? 0);

            return {
                id: nome,
                progresso,
                quantidadeAprendida,
                totalGirias,
                progressoMaximo,
                diplomaDesbloqueado: progressoMaximo >= 1,
            };
        })
    );

    return resultados;
}

/**
 * Helper interno: busca os ids aprendidos pelo usuário num mundo e devolve
 * já como Set<string>, pronto pra comparar com `String(giria.id)`.
 * Usado tanto pra filtrar (lista só de aprendidas) quanto pra marcar
 * (lista completa com flag `aprendida`).
 */
async function buscarIdsAprendidosSet(
    nomeDoMundo: string,
    idUsuario: number,
    idioma = 'pt',
): Promise<Set<string>> {
    const idMundoNumerico = await buscarIdMundoPorNome(nomeDoMundo);
    const idsAprendidos = idMundoNumerico !== null
        ? await buscarGiriasAprendidas(idMundoNumerico, idUsuario, idioma)
        : [];
    return new Set(idsAprendidos.map(String));
}

/**
 * Retorna, com nome e significado, as gírias que o usuário JÁ aprendeu
 * (≥80% de acerto em alguma rodada) num mundo específico. Base pra uma
 * tela de "dicionário pessoal" / revisão.
 */
export async function listarGiriasAprendidasDoMundo(
    nomeDoMundo: string,
    idUsuario: number,
    idioma = 'pt',
): Promise<Array<{
    id: number | string;
    nome: string;
    significado: string;
    exemplo: string;
    classe?: string;
    impacto?: string;
}>> {
    const mundo = nomeDoMundo.trim().toLowerCase();
    if (!NOMES_MUNDOS.includes(mundo as (typeof NOMES_MUNDOS)[number])) {
        throw new Error('Mundo não encontrado!');
    }

    const todasAsGiriasDoMundo = obterGiriasDoMundo(mundo, idioma);
    const idsAprendidosSet = await buscarIdsAprendidosSet(mundo, idUsuario, idioma);

    return todasAsGiriasDoMundo
        .filter((giria) => idsAprendidosSet.has(String(giria.id)))
        .map((giria) => ({
            id: giria.id,
            nome: giria.nome,
            significado: giria.significado,
            exemplo: giria.exemplo_correto,
            classe: giria.classe_gramatical ?? (giria as any).classe,
            impacto: giria.impacto,
        }));
}

/**
 * Igual a `listarGiriasAprendidasDoMundo`, mas devolve TODAS as gírias
 * do mundo (aprendidas + ainda trancadas), cada uma marcada com
 * `aprendida: true/false`. É essa que a tela "dicionário do mundo" usa
 * pra desenhar os cards trancados em cinza ao lado dos já aprendidos.
 */
export async function listarTodasGiriasComStatusDoMundo(
    nomeDoMundo: string,
    idUsuario: number,
    idioma = 'pt',
): Promise<Array<{
    id: number | string;
    nome: string;
    significado: string;
    exemplo: string;
    classe?: string;
    impacto?: string;
    aprendida: boolean;
}>> {
    const mundo = nomeDoMundo.trim().toLowerCase();
    if (!NOMES_MUNDOS.includes(mundo as (typeof NOMES_MUNDOS)[number])) {
        throw new Error('Mundo não encontrado!');
    }

    const todasAsGiriasDoMundo = obterGiriasDoMundo(mundo, idioma);
    const idsAprendidosSet = await buscarIdsAprendidosSet(mundo, idUsuario, idioma);

    return todasAsGiriasDoMundo.map((giria) => ({
        id: giria.id,
        nome: giria.nome,
        significado: giria.significado,
        exemplo: giria.exemplo_correto,
        classe: giria.classe_gramatical ?? (giria as any).classe,
        impacto: giria.impacto,
        aprendida: idsAprendidosSet.has(String(giria.id)),
    }));
}

/**
 * Mesma coisa, mas pra TODOS os mundos de uma vez, agrupado por mundo.
 * Útil pra montar a tela geral de "gírias aprendidas" sem precisar de
 * uma chamada por mundo no front.
 */
export async function listarGiriasAprendidasPorTodosMundos(
    idUsuario: number,
    idioma = 'pt',
): Promise<Array<{
    mundo: string;
    girias: Array<{
        id: number | string;
        nome: string;
        significado: string;
        exemplo: string;
        classe?: string;
        impacto?: string;
    }>;
}>> {
    const nomesDosMundos = [...NOMES_MUNDOS];

    return Promise.all(
        nomesDosMundos.map(async (nome) => ({
            mundo: nome,
            girias: await listarGiriasAprendidasDoMundo(nome, idUsuario, idioma),
        }))
    );
}

export function contarGiriasPorMundos(idioma = 'pt'): Record<string, number> {
    return contarGiriasDoDicionario(idiomaValido(idioma) ? idioma : 'pt');
}