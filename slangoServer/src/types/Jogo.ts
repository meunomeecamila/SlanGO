export interface Girias {
  id: number;
  nome: string;
  variacoes: string[];
  classe_gramatical: string;
  significado: string;
  tags: string[];
  permissao: string;
  impacto: string;
  /** Explicação do porquê da gíria ter esse impacto (opcional nos JSONs antigos) */
  impacto_motivo?: string;
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
  Administrador: boolean;
  Senha: string;
  Data: string; // ou Date, dependendo de como o driver do banco devolve
  perguntaSeguranca: string;
  respostaSeguranca: string;
  id_Astronauta: number | null; // avatar escolhido livremente pelo usuário
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

// ── Avatar (Astronauta) e Itens desbloqueáveis ──

/** Astronauta disponível como avatar. Qualquer usuário pode escolher qualquer um, a qualquer momento. */
export interface Astronauta {
  id: number;
  nome: string;
  url_astronauta: string;
}

/** Item cosmético do perfil. Cada item pertence a um Mundo e é desbloqueado ao atingir o limiar de progresso nesse mundo. */
export interface Item {
  id: number;
  nome: string;
  url_item: string;
  id_Mundo: number;
}

/** Espelha a tabela de junção user_item (posse + item equipado) */
export interface UsuarioItem {
  id_item: number;
  id_user: number;
  equipado: boolean;
}

/** Item com o status do usuário logado, usado na resposta de GET /perfil/itens */
export interface ItemComStatus extends Item {
  desbloqueado: boolean;
  equipado: boolean;
}

export interface RegistroRanking {
    idUsuario: number;
    idMundo: number;
    nomeUsuario: string;
    tempoMs: number;
    pontuacao: number;
    percentualAcerto: number;
}

export interface ItemRanking {
    posicao: number;
    idUsuario: number;
    melhorTempoMs: number;
    pontuacao: number;
}

export interface PosicaoUsuario {
    posicao: number | null;
    nomeUsuario: string | null;
    melhorTempoMs: number | null;
    totalJogadores: number;
}

export type StatusSugestao = 'PENDENTE' | 'APROVADO' | 'REJEITADO';
export type ImpactoGiria = 'positiva' | 'negativa' | 'neutra' | 'depende_de_contexto';

export interface SugestaoGiria {
  id: number;
  usuario_id: number | null;
  nome: string;
  significado: string;
  exemplo: string;
  impacto: ImpactoGiria;
  impacto_motivo?: string;
  tags: string[];
  classe_gramatical?: string;
  status: StatusSugestao;
  criado_em: string;
}

export type DadosCriacaoSugestao = Pick<
  SugestaoGiria,
  'nome' | 'significado' | 'exemplo' | 'impacto' | 'impacto_motivo' | 'tags' | 'classe_gramatical'
>;

// Body opcional de edição no momento da aprovação
export type DadosAprovacaoSugestao = Partial<DadosCriacaoSugestao>;