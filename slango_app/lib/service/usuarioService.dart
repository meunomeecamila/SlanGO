import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../user/User.dart';

class UsuarioService {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _userIdKey = 'userId';
  static const _isGuestKey =
      'isGuest'; // flag local: sessão atual é de convidado?

  static String get _baseUrl {
    final url = dotenv.env['API_URL']?.trim();
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_URL não definida. Configure a variável API_URL no arquivo .env '
        'antes de usar o app (ex: API_URL=http://10.0.2.2:3000).',
      );
    }

    final baseSemBarra = url.endsWith('/')
        ? url.substring(0, url.length - 1)
        : url;
    return baseSemBarra.endsWith('/api') ? baseSemBarra : '$baseSemBarra/api';
  }

  static Future<void> _storeUserId(int id) async {
    await _storage.write(key: _userIdKey, value: id.toString());
  }

  static Future<int?> _getStoredUserId() async {
    final id = await _storage.read(key: _userIdKey);
    return id == null ? null : int.tryParse(id);
  }

  static Future<void> _clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _isGuestKey);
  }

  // ── Cadastro ──
  static Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
    bool responsavel = false,
    String? dataNascimento,
    // TODO: o backend precisa aceitar e persistir esses dois campos no
    // endpoint /cadastrar (coluna/campo pergunta_seguranca e
    // resposta_seguranca, por exemplo com hash da resposta).
    String? perguntaSeguranca,
    String? respostaSeguranca,
  }) async {
    final payload = <String, dynamic>{
      'nome': nome,
      'email': email,
      'senha': senha,
      'confirmarSenha': confirmarSenha,
      'responsavel': responsavel,
      if (dataNascimento != null) 'dataNascimento': dataNascimento,
      if (perguntaSeguranca != null && perguntaSeguranca.isNotEmpty)
        'perguntaSeguranca': perguntaSeguranca,
      if (respostaSeguranca != null && respostaSeguranca.isNotEmpty)
        'respostaSeguranca': respostaSeguranca,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/cadastrar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final usuario = Usuario.fromJson(dados['usuario']);
      await login(email, senha);
      return usuario;
    }

    throw Exception(dados['erro'] ?? 'Erro ao cadastrar usuário');
  }

  // ── Login ──
  static Future<Usuario> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Login de verdade sempre substitui uma sessão de convidado anterior
      await _storage.delete(key: _isGuestKey);
      await _storage.write(key: _tokenKey, value: dados['token']);
      await _storeUserId(dados['usuario']['id']);
      return Usuario.fromJson(dados['usuario']);
    }

    throw Exception(dados['erro'] ?? 'Email ou senha inválidos');
  }

  // ── Sessão de convidado ──
  // Não cria usuário nenhum: só pega um token temporário que dá acesso
  // apenas à listagem de mundos (o backend bloqueia o resto com 403).
  static Future<void> entrarComoConvidado() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/convidado'),
      headers: {'Content-Type': 'application/json'},
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(dados['erro'] ?? 'Erro ao entrar como convidado');
    }

    // Limpa qualquer resquício de sessão anterior (id de usuário real, se tinha)
    await _storage.delete(key: _userIdKey);
    await _storage.write(key: _tokenKey, value: dados['token']);
    await _storage.write(key: _isGuestKey, value: 'true');
  }

  /// Sessão atual é de convidado (sem conta de verdade)?
  static Future<bool> estaConvidado() async {
    final flag = await _storage.read(key: _isGuestKey);
    return flag == 'true';
  }

  // ── Buscar usuário por id (rota protegida) ──
  static Future<Usuario> buscarPorId(int id) async {
    final token = await _storage.read(key: _tokenKey);

    final response = await http.get(
      Uri.parse('$_baseUrl/usuario/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Usuario.fromJson(dados['usuario']);
    }

    if (response.statusCode == 401) {
      await _storage.delete(key: 'token');
      throw Exception('Sessão expirada. Faça login novamente.');
    }

    throw Exception(dados['erro'] ?? 'Erro ao buscar usuário');
  }

  // ── Atualizar usuário (rota protegida) ──
  static Future<Usuario> atualizar(
    int id, {
    String? nome,
    String? email,
    String? senha,
    bool? responsavel,
    String? dataNascimento,
    String? perguntaSeguranca,
    String? respostaSeguranca,
  }) async {
    final token = await _storage.read(key: _tokenKey);

    final corpo = <String, dynamic>{};
    if (nome != null) corpo['nome'] = nome;
    if (email != null) corpo['email'] = email;
    if (senha != null) corpo['senha'] = senha;
    if (responsavel != null) corpo['responsavel'] = responsavel;
    if (dataNascimento != null) corpo['dataNascimento'] = dataNascimento;
    if (perguntaSeguranca != null)
      corpo['perguntaSeguranca'] = perguntaSeguranca;
    if (respostaSeguranca != null)
      corpo['respostaSeguranca'] = respostaSeguranca;

    final response = await http.put(
      Uri.parse('$_baseUrl/usuario/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(corpo),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Usuario.fromJson(dados['usuario']);
    }

    if (response.statusCode == 401) {
      await _storage.delete(key: 'token');
      throw Exception('Sessão expirada. Faça login novamente.');
    }

    throw Exception(dados['erro'] ?? 'Erro ao atualizar usuário');
  }

  // ── Deletar usuário (rota protegida) ──
  static Future<void> deletar([int? id]) async {
    final token = await _storage.read(key: _tokenKey);
    final userId = id ?? await _getStoredUserId();

    if (userId == null) {
      throw Exception('Usuário não identificado. Faça login novamente.');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/usuario/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await _clearSession();
      return;
    }

    final dados = jsonDecode(response.body);
    throw Exception(dados['erro'] ?? 'Erro ao deletar usuário');
  }

  static Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
    required String confirmarNovaSenha,
  }) async {
    final token = await _storage.read(key: _tokenKey);
    final userId = await _getStoredUserId();

    if (userId == null) {
      throw Exception('Usuário não identificado. Faça login novamente.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/usuario/$userId/alterar-senha'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'senhaAtual': senhaAtual,
        'novaSenha': novaSenha,
        'confirmarNovaSenha': confirmarNovaSenha,
      }),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 401) {
      await _storage.delete(key: 'token');
      throw Exception('Senha atual incorreta.');
    }

    throw Exception(dados['erro'] ?? 'Erro ao alterar senha');
  }

  static Future<String> obterPerguntaSeguranca(String email) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/recuperar-senha/pergunta?email=${Uri.encodeQueryComponent(email)}',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.body.trim().isEmpty) {
      throw Exception(
        'Resposta vazia do servidor ao buscar pergunta de segurança',
      );
    }

    final dados = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final pergunta = dados['perguntaSeguranca'];
      if (pergunta is String && pergunta.trim().isNotEmpty) {
        return pergunta.trim();
      }
      if (pergunta != null) {
        return pergunta.toString().trim();
      }
      return '';
    }

    throw Exception(dados['erro'] ?? 'Erro ao buscar pergunta de segurança');
  }

  static Future<void> recuperarSenha({
    required String email,
    required String novaSenha,
    required String confirmarNovaSenha,
    required String respostaSeguranca,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/recuperar-senha'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'novaSenha': novaSenha,
        'confirmarNovaSenha': confirmarNovaSenha,
        'respostaSeguranca': respostaSeguranca,
      }),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(dados['erro'] ?? 'Erro ao recuperar senha');
  }

  static Future<Usuario> buscarUsuarioLogado() async {
    final id = await _getStoredUserId();
    if (id == null) {
      throw Exception('Usuário não identificado. Faça login novamente.');
    }
    return buscarPorId(id);
  }

  static Future<String?> obterNomeUsuarioOuNull() async {
    try {
      if (await estaConvidado()) return null;
      final usuario = await buscarUsuarioLogado();
      return usuario.nome;
    } catch (_) {
      return null;
    }
  }

  static Future<void> logout() async {
    await _clearSession();
  }

  static Future<bool> estaLogado() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }
}