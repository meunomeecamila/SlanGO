import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET as string; 
const EXPIRA_EM = '1h'; 

export function gerarToken(payload: { id: number; email: string }) {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: EXPIRA_EM });
}

export function verificarToken(token: string) {
    return jwt.verify(token, JWT_SECRET) as { id: number; email: string; iat: number; exp: number };
}