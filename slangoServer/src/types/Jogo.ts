export interface Girias {
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

export interface Usuario {
  id: number;
  nome: string;
  sobrenome: string;
  email: string;
  senha: string;
  permissao: string;
  nivel: number;
  acessorios: string[];
}
export interface Personagem {
  id: number;
  nome: string;
  tipo: string;
  acessorio: string;
  falas: string[];
}
export interface UsuarioFase {
  id: number;
  idUsuario: number;
  idFase: number;   
  girias: string[];
}
export interface UsuarioPersonagem {
  id: number;
  idUsuario: number;    
  idPersonagem: number; 
}

