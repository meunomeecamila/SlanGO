import bcrypt from 'bcrypt';
import { supabase } from '../dbConnection';
import { Usuario } from '../types/Jogo';

const TABELA_USUARIO = 'User';

export async function buscarUsuarioPorEmail(email: string): Promise<Usuario | null> {
    const { data, error } = await supabase
        .from(TABELA_USUARIO)
        .select('*')
        .ilike('Email', email) 
        .maybeSingle();

    if (error) {
        console.error('Erro ao buscar usuário por email:', error);
        return null;
    }

    return data as Usuario | null;
}


export async function validarRespostaSeguranca(
    respostaEnviada: string,
    valorSalvo: string
): Promise<boolean> {
    const respostaNormalizada = respostaEnviada.trim().toLowerCase();
    const valorSalvoNormalizado = valorSalvo.trim().toLowerCase();
    return respostaNormalizada === valorSalvoNormalizado;
}

export async function atualizarSenhaUsuario(idUsuario: number, novaSenha: string): Promise<void> {
    const novaSenhaHash = await bcrypt.hash(novaSenha, 10);

    const { error } = await supabase
        .from(TABELA_USUARIO)
        .update({ Senha: novaSenhaHash })
        .eq('id', idUsuario);

    if (error) {
        console.error('Erro ao atualizar senha:', error);
        throw new Error('Não foi possível atualizar a senha.');
    }
}