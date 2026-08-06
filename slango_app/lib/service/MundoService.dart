import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- Trocamos para secure storage

import '../fase/fase.dart';

class MundoService {
  // Instanciamos o secure storage igual você fez no UsuarioService
  static const _storage = FlutterSecureStorage();

  static String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL não definida.');
    }
    return url;
  }

  // 1. Atualizado para buscar no FlutterSecureStorage com a chave 'token'
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'token');

    return {
      'Content-Type': 'application/json',
      // Injeta o token se ele existir
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ==========================================
  // ROTA DE PROGRESSO
  // ==========================================
  static Future<List<Map<String, dynamic>>> obterProgressoMundos() async {
    final uri = Uri.parse('$_baseUrl/mundos/progresso');

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar progresso: ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse is Map<String, dynamic> &&
        jsonResponse['mundos'] is List) {
      return List<Map<String, dynamic>>.from(jsonResponse['mundos']);
    }
    if (jsonResponse is List) {
      return List<Map<String, dynamic>>.from(jsonResponse);
    }
    return [];
  }

  // ==========================================
  // BUSCAR FASES DO MUNDO
  // ==========================================
  static Future<RodadaMundo> buscarRodada(String nomeMundo) async {
    final uri = Uri.parse('$_baseUrl/mundos/$nomeMundo/fases');

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar rodada: ${response.body}');
    }

    return RodadaMundo.fromJson(jsonDecode(response.body));
  }

  // ==========================================
  // VALIDAR RESULTADO
  // ==========================================
  static Future<Map<String, dynamic>> validarResultado({
    required String nomeDoMundo,
    required int pontuacaoFinal,
    required List<dynamic> girias, // Agora recebe a lista de IDs
  }) async {
    final uri = Uri.parse('$_baseUrl/mundos/resultado');

    final headers = await _getHeaders();
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'nomeDoMundo': nomeDoMundo,
        'pontuacaoFinal': pontuacaoFinal,
        'girias': girias, // Envia o array de IDs para o backend
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao validar resultado: ${response.body}');
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> progressoMundo(String nomeDoMundo) async {
    final uri = Uri.parse('$_baseUrl/mundos/$nomeDoMundo/progresso');

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar progresso do mundo: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}
