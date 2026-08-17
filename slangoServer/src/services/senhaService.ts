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

// A senha agora vive no Supabase Auth — não tem mais hash nem coluna
// "Senha" pra atualizar aqui, só repassa pro Auth via authId.
export async function atualizarSenhaUsuario(authId: string, novaSenha: string): Promise<void> {
    const { error } = await supabase.auth.admin.updateUserById(authId, {
        password: novaSenha,
    });

    if (error) {
        console.error('Erro ao atualizar senha:', error);
        throw new Error('Não foi possível atualizar a senha.');
    }
}