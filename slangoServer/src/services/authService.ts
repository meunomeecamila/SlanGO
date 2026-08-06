import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET as string;
const EXPIRA_EM = '1h';
const EXPIRA_EM_CONVIDADO = '1h'; 
export interface PayloadUsuario {
    id: number;
    email: string;
    convidado?: false;
}

export interface PayloadConvidado {
    convidado: true;
}

export type PayloadToken = (PayloadUsuario | PayloadConvidado) & {
    iat: number;
    exp: number;
};

export function gerarToken(payload: { id: number; email: string }) {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: EXPIRA_EM });
}

export function gerarTokenConvidado() {
    return jwt.sign({ convidado: true }, JWT_SECRET, { expiresIn: EXPIRA_EM_CONVIDADO });
}

export function verificarToken(token: string): PayloadToken {
    return jwt.verify(token, JWT_SECRET) as PayloadToken;
}