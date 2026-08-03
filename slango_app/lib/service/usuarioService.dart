import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../user/User.dart';

class UsuarioService {
  static const _storage = FlutterSecureStorage();

  static String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_URL não definida. Configure a variável API_URL no arquivo .env '
        'antes de usar o app (ex: API_URL=http://10.0.2.2:3000).',
      );
    }
    return url;
  }

  // ── Cadastro ──
  static Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
    bool responsavel = false,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cadastrar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'confirmarSenha': confirmarSenha,
        'responsavel': responsavel,
      }),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return Usuario.fromJson(dados['usuario']);
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

    if (response.statusCode == 200) {
      await _storage.write(key: 'token', value: dados['token']);
      return Usuario.fromJson(dados['usuario']);
    }

    throw Exception(dados['erro'] ?? 'Email ou senha inválidos');
  }

  // ── Buscar usuário por id (rota protegida) ──
  static Future<Usuario> buscarPorId(int id) async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$_baseUrl/usuarios/$id'),
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
  }) async {
    final token = await _storage.read(key: 'token');

    final corpo = <String, dynamic>{};
    if (nome != null) corpo['nome'] = nome;
    if (email != null) corpo['email'] = email;
    if (senha != null) corpo['senha'] = senha;
    if (responsavel != null) corpo['responsavel'] = responsavel;

    final response = await http.put(
      Uri.parse('$_baseUrl/usuarios/$id'),
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
  static Future<void> deletar(int id) async {
    final token = await _storage.read(key: 'token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/usuarios/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await _storage.delete(key: 'token');
      return;
    }

    final dados = jsonDecode(response.body);
    throw Exception(dados['erro'] ?? 'Erro ao deletar usuário');
  }

  // ── Logout local ──
  static Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  static Future<bool> estaLogado() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }
}