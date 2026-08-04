export interface Girias {
  id: number;
  nome: string;
  variacoes: string[];
  classe_gramatical: string;
  significado: string;
  tags: string[];
  permissao: string;
  impacto: string;
  exemplo_correto: string;
  exemplos_incorretos: string[];
  significados_incorretos: string[];
}

export interface Alternativa {
  texto: string;
  correta: boolean;
}

export interface FaseMundo {
  id: number;
  giria: string;
  variacoes: string[]; // Variações/abreviações da gíria — usadas na Tela de Estudo
  pergunta: string;
  explicacao: string;
  alternativas: Alternativa[];
}

export interface FaseGiria {
  id: number;
  idFase: number;
  idGiria: number;
}

// ── Modelos ligados ao banco (schema atual do diagrama) ──

export interface Mundo {
  id: number;
  nome: string;
  acessoPersonagem: boolean;
  quantidadeTotal: number;
}

export interface Usuario {
  id: number;
  Nome: string;
  Email: string;
  Responsavel: boolean;
  Senha: string;
  Data: string; // ou Date, dependendo de como o driver do banco devolve
}

/** Versão segura para respostas da API — nunca inclui a senha */
export type UsuarioPublico = Omit<Usuario, 'Senha'>;

/** Espelha a tabela de junção user_mundo (progresso por mundo, não por fase) */
export interface UsuarioMundo {
  idMundo: number;
  idUser: number;
  giriasAprendidas: string; // "text" no banco — pode ser JSON stringificado ou lista separada por vírgula
  progresso: number; // float4
  quantidadeAprendida: number; // int8
}

export interface Personagem {
  id: number;
  nome: string;
  tipo: string;
  acessorio: string;
  falas: string[];
}

export interface UsuarioPersonagem {
  id: number;
  idUsuario: number;
  idPersonagem: number;
}

export interface ColecaoDeMundos {
  [chaveDinamica: string]: Girias[];
}