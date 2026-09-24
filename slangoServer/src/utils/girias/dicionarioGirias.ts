import ptAntigo from './pt_antigo.json';
import enAntigo from './en_antigo.json';
import esAntigo from './es_antigo.json';
import itAntigo from './it_antigo.json';

import ptCotidiano from './pt_cotidiano.json';
import enCotidiano from './en_cotidiano.json';
import esCotidiano from './es_cotidiano.json';
import itCotidiano from './it_cotidiano.json';

import ptEsportes from './pt_esportes.json';
import enEsportes from './en_esportes.json';
import esEsportes from './es_esportes.json';
import itEsportes from './it_esportes.json';

import ptGeek from './pt_geek.json';
import enGeek from './en_geek.json';
import esGeek from './es_geek.json';
import itGeek from './it_geek.json';

import ptJogos from './pt_jogos.json';
import enJogos from './en_jogos.json';
import esJogos from './es_jogos.json';
import itJogos from './it_jogos.json';

import ptKpop from './pt_kpop.json';
import enKpop from './en_kpop.json';
import esKpop from './es_kpop.json';
import itKpop from './it_kpop.json';

import ptMaquiagem from './pt_maquiagem.json';
import enMaquiagem from './en_maquiagem.json';
import esMaquiagem from './es_maquiagem.json';
import itMaquiagem from './it_maquiagem.json';

import ptPop from './pt_pop.json';
import enPop from './en_pop.json';
import esPop from './es_pop.json';
import itPop from './it_pop.json';

import ptRedesSociais from './pt_redessociais.json';
import enRedesSociais from './en_redessociais.json';

import ptRelacionamentos from './pt_relacionamentos.json';
import enRelacionamentos from './en_relacionamentos.json';
import esRelacionamentos from './es_relacionamentos.json';
import itRelacionamentos from './it_relacionamentos.json';

import ptComunidade from './pt_comunidade.json';
import enComunidade from './en_comunidade.json';
import esComunidade from './es_comunidade.json';
import itComunidade from './it_comunidade.json';

import { Girias } from '../../types/Jogo';

export const IDIOMAS_SUPORTADOS = ['pt', 'en', 'es', 'it'] as const;
export type IdiomaSuportado = (typeof IDIOMAS_SUPORTADOS)[number];

export const IDIOMA_PADRAO: IdiomaSuportado = 'pt';

export const NOMES_MUNDOS = [
  'antigo',
  'cotidiano',
  'esportes',
  'geek',
  'jogos',
  'kpop',
  'maquiagem',
  'pop',
  'redessociais',
  'relacionamentos',
  'comunidade',
] as const;

export type NomeMundo = (typeof NOMES_MUNDOS)[number];

/**
 * Os JSONs vieram de origens diferentes: alguns são um array direto de gírias,
 * outros são um objeto com uma única chave (ex: `{ "geek": [...] }`).
 * Esta função normaliza os dois formatos para um array de `Girias`.
 */
function extrairGirias(dados: unknown): Girias[] {
  if (Array.isArray(dados)) return dados as Girias[];

  if (dados && typeof dados === 'object') {
    for (const valor of Object.values(dados)) {
      if (Array.isArray(valor)) return valor as Girias[];
    }
  }

  return [];
}

type MapaPorIdioma = Partial<Record<IdiomaSuportado, Girias[]>>;

/**
 * Mapa estático `mundo -> idioma -> gírias`.
 *
 * Idiomas ausentes são intencionais: quando a tradução daquele mundo ainda não
 * existe, `obterGiriasDoMundo` cai no português para manter o mundo jogável.
 * Hoje faltam apenas `es` e `it` do mundo `redessociais` (os arquivos de origem
 * traziam, por engano, o conteúdo do mundo `geek`).
 */
const dicionarioGirias: Record<NomeMundo, MapaPorIdioma> = {
  antigo: {
    pt: extrairGirias(ptAntigo),
    en: extrairGirias(enAntigo),
    es: extrairGirias(esAntigo),
    it: extrairGirias(itAntigo),
  },
  cotidiano: {
    pt: extrairGirias(ptCotidiano),
    en: extrairGirias(enCotidiano),
    es: extrairGirias(esCotidiano),
    it: extrairGirias(itCotidiano),
  },
  esportes: {
    pt: extrairGirias(ptEsportes),
    en: extrairGirias(enEsportes),
    es: extrairGirias(esEsportes),
    it: extrairGirias(itEsportes),
  },
  geek: {
    pt: extrairGirias(ptGeek),
    en: extrairGirias(enGeek),
    es: extrairGirias(esGeek),
    it: extrairGirias(itGeek),
  },
  jogos: {
    pt: extrairGirias(ptJogos),
    en: extrairGirias(enJogos),
    es: extrairGirias(esJogos),
    it: extrairGirias(itJogos),
  },
  kpop: {
    pt: extrairGirias(ptKpop),
    en: extrairGirias(enKpop),
    es: extrairGirias(esKpop),
    it: extrairGirias(itKpop),
  },
  maquiagem: {
    pt: extrairGirias(ptMaquiagem),
    en: extrairGirias(enMaquiagem),
    es: extrairGirias(esMaquiagem),
    it: extrairGirias(itMaquiagem),
  },
  pop: {
    pt: extrairGirias(ptPop),
    en: extrairGirias(enPop),
    es: extrairGirias(esPop),
    it: extrairGirias(itPop),
  },
  redessociais: {
    pt: extrairGirias(ptRedesSociais),
    en: extrairGirias(enRedesSociais),
  },
  relacionamentos: {
    pt: extrairGirias(ptRelacionamentos),
    en: extrairGirias(enRelacionamentos),
    es: extrairGirias(esRelacionamentos),
    it: extrairGirias(itRelacionamentos),
  },
  comunidade: {
    pt: extrairGirias(ptComunidade),
    en: extrairGirias(enComunidade),
    es: extrairGirias(esComunidade),
    it: extrairGirias(itComunidade),
  },
};

export function idiomaValido(idioma: string): idioma is IdiomaSuportado {
  return (IDIOMAS_SUPORTADOS as readonly string[]).includes(idioma);
}

/** Normaliza entradas como 'pt_BR', 'EN', 'es-ES' para um idioma suportado. */
export function normalizarIdioma(idioma?: string | null): IdiomaSuportado {
  const base = (idioma ?? '').trim().toLowerCase().split(/[_-]/)[0];
  return idiomaValido(base) ? base : IDIOMA_PADRAO;
}

function normalizarMundo(nomeMundo: string): NomeMundo | null {
  const chave = (nomeMundo ?? '')
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[\s_-]/g, '');

  const equivalencias: Record<string, NomeMundo> = {
    antigo: 'antigo',
    antigas: 'antigo',
    giriasantigas: 'antigo',
    cotidiano: 'cotidiano',
    esporte: 'esportes',
    esportes: 'esportes',
    geek: 'geek',
    jogos: 'jogos',
    jogo: 'jogos',
    kpop: 'kpop',
    maquiagem: 'maquiagem',
    pop: 'pop',
    redessociais: 'redessociais',
    redesocial: 'redessociais',
    relacionamento: 'relacionamentos',
    relacionamentos: 'relacionamentos',
    comunidade: 'comunidade',
  };

  return equivalencias[chave] ?? null;
}

/**
 * Retorna as gírias de um mundo no idioma pedido.
 * Fallback: idioma pedido -> português do mesmo mundo -> comunidade em português.
 */
export function obterGiriasDoMundo(
  nomeMundo: string,
  idioma: string = IDIOMA_PADRAO,
): Girias[] {
  const mundo = normalizarMundo(nomeMundo);
  const idiomaNormalizado = normalizarIdioma(idioma);

  if (!mundo) {
    return dicionarioGirias.comunidade[IDIOMA_PADRAO] ?? [];
  }

  const porIdioma = dicionarioGirias[mundo];
  const girias = porIdioma[idiomaNormalizado];

  if (girias && girias.length > 0) return girias;

  return (
    porIdioma[IDIOMA_PADRAO] ??
    dicionarioGirias.comunidade[IDIOMA_PADRAO] ??
    []
  );
}

/** Contagem real de gírias por mundo no idioma pedido. Nunca use número fixo do banco. */
export function contarGiriasPorMundos(
  idioma: string = IDIOMA_PADRAO,
): Record<string, number> {
  return Object.fromEntries(
    NOMES_MUNDOS.map((nome) => [nome, obterGiriasDoMundo(nome, idioma).length]),
  );
}

/** Total de gírias de um mundo específico no idioma pedido. */
export function contarGiriasDoMundo(
  nomeMundo: string,
  idioma: string = IDIOMA_PADRAO,
): number {
  return obterGiriasDoMundo(nomeMundo, idioma).length;
}
