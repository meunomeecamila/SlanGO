import bcrypt from 'bcrypt';
import { Usuario, UsuarioPublico } from '../types/Jogo';
import { supabase } from '../dbConnection';

const SALT_ROUNDS = 10;

type DadosCriacaoUsuario = Pick<Usuario, 'nome' | 'email' | 'senha' | 'responsavel'>;

function removerSenha(usuario: Usuario): UsuarioPublico {
    const { senha, ...usuarioPublico } = usuario;
    return usuarioPublico;
}

export async function criarUsuario(dados: DadosCriacaoUsuario): Promise<UsuarioPublico> {
    const emailExistente = await buscarUsuarioPorEmail(dados.email);
    if (emailExistente) {
        throw new Error('EMAIL_JA_CADASTRADO');
    }

    const senhaHash = await bcrypt.hash(dados.senha, SALT_ROUNDS);

    const { data, error } = await supabase
        .from('User')
        .insert([
            {
                nome: dados.nome,
                email: dados.email,
                senha: senhaHash,
                responsavel: dados.responsavel ?? false
            }
        ])
        .select();

    if (error) throw new Error(error.message);

    return removerSenha(data[0]);
}

export async function buscarUsuarioPorEmail(email: string): Promise<Usuario | null> {
    const { data, error } = await supabase
        .from('User')
        .select('*')
        .eq('email', email)
        .maybeSingle();

    if (error) throw new Error(error.message);
    return data as Usuario | null;
}


export async function validarCredenciais(email: string, senhaDigitada: string): Promise<UsuarioPublico | null> {
    const usuario = await buscarUsuarioPorEmail(email);
    if (!usuario) return null;

    const senhaCorreta = await bcrypt.compare(senhaDigitada, usuario.senha);
    if (!senhaCorreta) return null;

    return removerSenha(usuario);
}