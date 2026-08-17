import { Usuario, UsuarioPublico } from '../types/Jogo';
import { supabase } from '../dbConnection';

const IDADE_MINIMA = 13;

// Senha, emailVerificado, tokenConfirmacao e tokenExpiraEm saem daqui:
// isso tudo agora é responsabilidade do Supabase Auth.
// `authId` é o vínculo entre a linha de perfil (tabela "User") e o usuário
// no Supabase Auth (auth.users.id).
// `Senha` não existe mais em `Usuario` (a senha só vive no Supabase Auth),
// por isso ela é declarada aqui à parte em vez de vir de `Pick<Usuario, ...>`.
type DadosCriacaoUsuario = Pick<Usuario, 'Nome' | 'Email' | 'Responsavel' | 'Data' | 'perguntaSeguranca' | 'respostaSeguranca'> & {
    Senha: string;
};
type DadosAtualizacaoUsuario = Partial<Pick<Usuario, 'Nome' | 'Email' | 'Responsavel' | 'Data' | 'perguntaSeguranca' | 'respostaSeguranca'>> & {
    Senha?: string;
};

export function calcularIdade(dataNascimento: string): number {
    const nascimento = new Date(dataNascimento);
    const hoje = new Date();

    let idade = hoje.getFullYear() - nascimento.getFullYear();
    const mesAtual = hoje.getMonth() - nascimento.getMonth();

    if (mesAtual < 0 || (mesAtual === 0 && hoje.getDate() < nascimento.getDate())) {
        idade--;
    }

    return idade;
}

export function dataNascimentoValida(dataNascimento: string): { valida: boolean; erro?: string } {
    const data = new Date(dataNascimento);

    if (isNaN(data.getTime())) {
        return { valida: false, erro: 'Data de nascimento inválida.' };
    }

    if (data > new Date()) {
        return { valida: false, erro: 'Data de nascimento não pode ser no futuro.' };
    }

    const idade = calcularIdade(dataNascimento);
    if (idade < IDADE_MINIMA) {
        return { valida: false, erro: `Idade mínima para cadastro é ${IDADE_MINIMA} anos.` };
    }

    return { valida: true };
}

export async function criarUsuario(dados: DadosCriacaoUsuario): Promise<UsuarioPublico> {
    const validacaoData = dataNascimentoValida(dados.Data);
    if (!validacaoData.valida) {
        throw new Error(validacaoData.erro);
    }
    
    const { data: authData, error: authError } = await supabase.auth.signUp({
        email: dados.Email,
        password: dados.Senha,
    });

    if (authError) {
        // Supabase retorna 422/"User already registered" pra email duplicado.
        if (authError.status === 422 || /already registered/i.test(authError.message)) {
            throw new Error('EMAIL_JA_CADASTRADO');
        }
        throw new Error(authError.message);
    }

    if (!authData.user) {
        throw new Error('Não foi possível criar o usuário.');
    }

    // Perfil da aplicação, vinculado ao usuário do Auth via authId.
    const { data, error } = await supabase
        .from('User')
        .insert([
            {
                authId: authData.user.id,
                Nome: dados.Nome,
                Email: dados.Email,
                Responsavel: dados.Responsavel ?? false,
                Data: dados.Data,
                perguntaSeguranca: dados.perguntaSeguranca,
                respostaSeguranca: dados.respostaSeguranca,
            }
        ])
        .select()
        .single();

    if (error) {
        // Perfil falhou depois do Auth já ter criado o usuário — evita ficar
        // com um usuário "fantasma" no Auth sem perfil correspondente.
        await supabase.auth.admin.deleteUser(authData.user.id);
        throw new Error(error.message);
    }

    return data as UsuarioPublico;
}

export async function reenviarConfirmacaoEmail(email: string): Promise<boolean> {
    const { error } = await supabase.auth.resend({
        type: 'signup',
        email,
    });

    // Mantém retorno booleano simples: quem decide a mensagem genérica
    // pro cliente é o controller (padrão anti-enumeração já usado antes).
    return !error;
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

export async function buscarUsuarioPorAuthId(authId: string): Promise<UsuarioPublico | null> {
    const { data, error } = await supabase
        .from('User')
        .select('*')
        .eq('authId', authId)
        .maybeSingle();

    if (error) throw new Error(error.message);
    return data as UsuarioPublico | null;
}

export async function buscarUsuarioPorId(id: number): Promise<UsuarioPublico | null> {
    const { data, error } = await supabase
        .from('User')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (error) throw new Error(error.message);
    return data as UsuarioPublico | null;
}

export async function atualizarUsuario(id: number, dados: DadosAtualizacaoUsuario): Promise<UsuarioPublico | null> {
    const usuarioExistente = await buscarUsuarioPorId(id);
    if (!usuarioExistente) return null;

    // Email e senha agora vivem no Supabase Auth — atualiza lá, não na
    // tabela de perfil.
    if (dados.Email !== undefined || dados.Senha) {
        const atualizacaoAuth: { email?: string; password?: string } = {};
        if (dados.Email !== undefined) atualizacaoAuth.email = dados.Email;
        if (dados.Senha) atualizacaoAuth.password = dados.Senha;

        const { error: erroAuth } = await supabase.auth.admin.updateUserById(
            (usuarioExistente as any).authId,
            atualizacaoAuth
        );
        if (erroAuth) throw new Error(erroAuth.message);
    }

    const camposParaAtualizar: Record<string, any> = {};

    if (dados.Nome !== undefined) camposParaAtualizar.Nome = dados.Nome;
    if (dados.Email !== undefined) camposParaAtualizar.Email = dados.Email;
    if (dados.Responsavel !== undefined) camposParaAtualizar.Responsavel = dados.Responsavel;
    if (dados.Data !== undefined) {
        const validacaoData = dataNascimentoValida(dados.Data);
        if (!validacaoData.valida) {
            throw new Error(validacaoData.erro);
        }
        camposParaAtualizar.Data = dados.Data;
    }
    if (dados.perguntaSeguranca !== undefined) camposParaAtualizar.perguntaSeguranca = dados.perguntaSeguranca;
    if (dados.respostaSeguranca !== undefined) camposParaAtualizar.respostaSeguranca = dados.respostaSeguranca;

    if (Object.keys(camposParaAtualizar).length === 0) {
        return usuarioExistente;
    }

    const { data, error } = await supabase
        .from('User')
        .update(camposParaAtualizar)
        .eq('id', id)
        .select()
        .single();

    if (error) throw new Error(error.message);
    return data as UsuarioPublico;
}

export async function deletarUsuario(id: number): Promise<boolean> {
    const usuario = await buscarUsuarioPorId(id);
    if (!usuario) return false;

    // Apaga o perfil e o usuário correspondente no Auth.
    const { error, count } = await supabase
        .from('User')
        .delete({ count: 'exact' })
        .eq('id', id);

    if (error) throw new Error(error.message);

    const authId = (usuario as any).authId;
    if (authId) {
        const { error: erroAuth } = await supabase.auth.admin.deleteUser(authId);
        if (erroAuth) console.error('Falha ao apagar usuário do Auth:', erroAuth.message);
    }

    return (count ?? 0) > 0;
}

export async function alterarSenhaUsuario(id: number, senhaAtual: string, novaSenha: string): Promise<boolean> {
    const usuario = await buscarUsuarioPorId(id);
    if (!usuario) return false;

    // Confirma a senha atual tentando autenticar com ela.
    const { error: erroLogin } = await supabase.auth.signInWithPassword({
        email: usuario.Email,
        password: senhaAtual,
    });
    if (erroLogin) return false;

    const { error } = await supabase.auth.admin.updateUserById((usuario as any).authId, {
        password: novaSenha,
    });

    if (error) throw new Error(error.message);
    return true;
}

export async function validarCredenciais(Email: string, senhaDigitada: string): Promise<UsuarioPublico | null> {
    const { data, error } = await supabase.auth.signInWithPassword({
        email: Email,
        password: senhaDigitada,
    });

    if (error) {
        if (/email not confirmed/i.test(error.message)) {
            throw new Error('EMAIL_NAO_VERIFICADO');
        }
        return null; // credenciais inválidas
    }

    if (!data.user) return null;

    return buscarUsuarioPorAuthId(data.user.id);
}

export async function obterNomeUsuarioOuNull(idUsuario: number): Promise<string | null> {
    const { data, error } = await supabase
        .from('User')
        .select('Nome')
        .eq('id', idUsuario)
        .single();

    if (error || !data) {
        return null;
    }

    return data.Nome ?? null;
}