import bcrypt from 'bcrypt';
import crypto from 'crypto';
import { Usuario, UsuarioPublico } from '../types/Jogo';
import { supabase } from '../dbConnection';
import { enviarEmailConfirmacao } from './emailService';

const SALT_ROUNDS = 10;
const IDADE_MINIMA = 13;
const TOKEN_EXPIRA_EM_MS = 1000 * 60 * 60; // 1h

// emailVerificado NÃO entra aqui de propósito: é um detalhe interno do fluxo
// de confirmação, nunca deve vir de fora (controller/client).
type DadosCriacaoUsuario = Pick<Usuario, 'Nome' | 'Email' | 'Senha' | 'Responsavel' | 'Data' | 'perguntaSeguranca' | 'respostaSeguranca'>;
type DadosAtualizacaoUsuario = Partial<Pick<Usuario, 'Nome' | 'Email' | 'Senha' | 'Responsavel' | 'Data' | 'perguntaSeguranca' | 'respostaSeguranca'>>;

function removerSenha(usuario: Usuario): UsuarioPublico {
    const { Senha, ...usuarioPublico } = usuario;
    return usuarioPublico;
}

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
    const emailExistente = await buscarUsuarioPorEmail(dados.Email);
    if (emailExistente) {
        throw new Error('EMAIL_JA_CADASTRADO');
    }

    const senhaHash = await bcrypt.hash(dados.Senha, SALT_ROUNDS);

    const validacaoData = dataNascimentoValida(dados.Data);
    if (!validacaoData.valida) {
        throw new Error(validacaoData.erro);
    }

    const tokenConfirmacao = crypto.randomBytes(32).toString('hex');
    const tokenExpiraEm = new Date(Date.now() + TOKEN_EXPIRA_EM_MS).toISOString();

    const { data, error } = await supabase
        .from('User')
        .insert([
            {
                Nome: dados.Nome,
                Email: dados.Email,
                Senha: senhaHash,
                Responsavel: dados.Responsavel ?? false,
                Data: dados.Data,
                perguntaSeguranca: dados.perguntaSeguranca,
                respostaSeguranca: dados.respostaSeguranca,
                emailVerificado: false,
                tokenConfirmacao,
                tokenExpiraEm
            }
        ])
        .select()
        .single();

    if (error) throw new Error(error.message);

    // Não deixa o cadastro falhar se o email tiver problema — só loga.
    try {
        await enviarEmailConfirmacao(dados.Email, tokenConfirmacao);
    } catch (erroEmail) {
        console.error('Falha ao enviar email de confirmação:', erroEmail);
    }

    return removerSenha(data);
}

export async function confirmarEmail(token: string): Promise<boolean> {
    const { data, error } = await supabase
        .from('User')
        .select('id, "tokenExpiraEm"')
        .eq('tokenConfirmacao', token)
        .maybeSingle();

    if (error) throw new Error(error.message);
    if (!data) return false;
    if (new Date(data.tokenExpiraEm) < new Date()) return false;

    const { error: errorUpdate } = await supabase
        .from('User')
        .update({ emailVerificado: true, tokenConfirmacao: null, tokenExpiraEm: null })
        .eq('id', data.id);

    if (errorUpdate) throw new Error(errorUpdate.message);
    return true;
}

export async function reenviarConfirmacaoEmail(email: string): Promise<boolean> {
    const usuario = await buscarUsuarioPorEmail(email);
    if (!usuario) return false;
    if (usuario.emailVerificado) return false;

    const tokenConfirmacao = crypto.randomBytes(32).toString('hex');
    const tokenExpiraEm = new Date(Date.now() + TOKEN_EXPIRA_EM_MS).toISOString();

    const { error } = await supabase
        .from('User')
        .update({ tokenConfirmacao, tokenExpiraEm })
        .eq('id', usuario.id);

    if (error) throw new Error(error.message);

    await enviarEmailConfirmacao(email, tokenConfirmacao);
    return true;
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
    if (dados.Data !== undefined) {
        const validacaoData = dataNascimentoValida(dados.Data);
        if (!validacaoData.valida) {
            throw new Error(validacaoData.erro);
        }
        camposParaAtualizar.Data = dados.Data;
    }
    if (dados.perguntaSeguranca !== undefined) camposParaAtualizar.perguntaSeguranca = dados.perguntaSeguranca;
    if (dados.respostaSeguranca !== undefined) camposParaAtualizar.respostaSeguranca = dados.respostaSeguranca;
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

export async function alterarSenhaUsuario(id: number, senhaAtual: string, novaSenha: string): Promise<boolean> {
    const { data, error } = await supabase
        .from('User')
        .select('Senha')
        .eq('id', id)
        .maybeSingle();

    if (error) throw new Error(error.message);
    if (!data) return false;

    const senhaCorreta = await bcrypt.compare(senhaAtual, data.Senha);
    if (!senhaCorreta) return false;

    const senhaHash = await bcrypt.hash(novaSenha, SALT_ROUNDS);

    const { error: errorAtualizacao } = await supabase
        .from('User')
        .update({ Senha: senhaHash })
        .eq('id', id);

    if (errorAtualizacao) throw new Error(errorAtualizacao.message);
    return true;
}

export async function validarCredenciais(Email: string, senhaDigitada: string): Promise<UsuarioPublico | null> {
    const usuario = await buscarUsuarioPorEmail(Email);
    if (!usuario) return null;

    const senhaCorreta = await bcrypt.compare(senhaDigitada, usuario.Senha);
    if (!senhaCorreta) return null;

    if (!usuario.emailVerificado) {
        throw new Error('EMAIL_NAO_VERIFICADO');
    }

    return removerSenha(usuario);
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
