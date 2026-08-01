import bcrypt from 'bcrypt';
import { Usuario, UsuarioPublico } from '../types/Jogo';
import { supabase } from '../dbConnection';

const SALT_ROUNDS = 10;

type DadosCriacaoUsuario = Pick<Usuario, 'Nome' | 'Email' | 'Senha' | 'Responsavel'>;
type DadosAtualizacaoUsuario = Partial<Pick<Usuario, 'Nome' | 'Email' | 'Senha' | 'Responsavel'>>;

function removerSenha(usuario: Usuario): UsuarioPublico {
    const { Senha, ...usuarioPublico } = usuario;
    return usuarioPublico;
}

export async function criarUsuario(dados: DadosCriacaoUsuario): Promise<UsuarioPublico> {
    const emailExistente = await buscarUsuarioPorEmail(dados.Email);
    if (emailExistente) {
        throw new Error('EMAIL_JA_CADASTRADO');
    }

    const senhaHash = await bcrypt.hash(dados.Senha, SALT_ROUNDS);

    const { data, error } = await supabase
        .from('User')
        .insert([
            {
                Nome: dados.Nome,
                Email: dados.Email,
                Senha: senhaHash,
                Responsavel: dados.Responsavel ?? false,
                Data: new Date().toISOString()
            }
        ])
        .select()
        .single();

    if (error) throw new Error(error.message);

    return removerSenha(data);
}

export async function buscarUsuarioPorEmail(Email: string): Promise<Usuario | null> {
    const { data, error } = await supabase
        .from('User')
        .select('*')
        .eq('Email', Email)
        .maybeSingle();

    if (error) throw new Error(error.message);
    return data as Usuario | null;
}

export async function buscarUsuarioPorId(id: number): Promise<UsuarioPublico | null> {
    const { data, error } = await supabase
        .from('User')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (error) throw new Error(error.message);
    return data ? removerSenha(data as Usuario) : null;
}

export async function atualizarUsuario(id: number, dados: DadosAtualizacaoUsuario): Promise<UsuarioPublico | null> {
    const usuarioExistente = await supabase
        .from('User')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (usuarioExistente.error) throw new Error(usuarioExistente.error.message);
    if (!usuarioExistente.data) return null;

    const camposParaAtualizar: Record<string, any> = {};

    if (dados.Nome !== undefined) camposParaAtualizar.Nome = dados.Nome;
    if (dados.Email !== undefined) camposParaAtualizar.Email = dados.Email;
    if (dados.Responsavel !== undefined) camposParaAtualizar.Responsavel = dados.Responsavel;
    if (dados.Senha) camposParaAtualizar.Senha = await bcrypt.hash(dados.Senha, SALT_ROUNDS);

    const { data, error } = await supabase
        .from('User')
        .update(camposParaAtualizar)
        .eq('id', id)
        .select()
        .single();

    if (error) throw new Error(error.message);
    return removerSenha(data);
}

export async function deletarUsuario(id: number): Promise<boolean> {
    const { error, count } = await supabase
        .from('User')
        .delete({ count: 'exact' })
        .eq('id', id);

    if (error) throw new Error(error.message);
    return (count ?? 0) > 0;
}

export async function validarCredenciais(Email: string, senhaDigitada: string): Promise<UsuarioPublico | null> {
    const usuario = await buscarUsuarioPorEmail(Email);
    if (!usuario) return null;

    const senhaCorreta = await bcrypt.compare(senhaDigitada, usuario.Senha);
    if (!senhaCorreta) return null;

    return removerSenha(usuario);
}