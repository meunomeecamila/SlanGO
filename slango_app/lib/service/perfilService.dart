import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../perfil/models.dart';

/// Serviço de perfil: astronautas (avatar, livre) e itens (desbloqueados por progresso).
/// Segue o mesmo padrão de _baseUrl/token do UsuarioService.dart.
class PerfilService {
  static const _storage = FlutterSecureStorage();

  static String get _baseUrl {
    final url = dotenv.env['API_URL']?.trim();
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_URL não definida. Configure a variável API_URL no arquivo .env.',
      );
    }

    final baseSemBarra = url.endsWith('/')
        ? url.substring(0, url.length - 1)
        : url;
    return baseSemBarra.endsWith('/api') ? baseSemBarra : '$baseSemBarra/api';
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Lista todos os astronautas disponíveis.
  static Future<List<AstronautaPerfil>> listarAstronautas() async {
    final response = await http.get(Uri.parse('$_baseUrl/astronautas'));
    final dados = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(dados['erro'] ?? 'Erro ao carregar astronautas.');
    }

    final lista = dados['astronautas'] as List;
    return lista
        .map((item) => AstronautaPerfil.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Atualiza o astronauta (avatar) escolhido pelo usuário logado.
  static Future<void> atualizarAvatar(int idAstronauta) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/perfil/avatar'),
      headers: await _getHeaders(),
      body: jsonEncode({'idAstronauta': idAstronauta}),
    );

    if (response.statusCode != 200) {
      final dados = jsonDecode(response.body);
      throw Exception(dados['erro'] ?? 'Erro ao atualizar avatar.');
    }
  }

  /// Lista todos os itens do jogo, com status de desbloqueado/equipado
  /// para o usuário logado.
  static Future<List<ItemPerfil>> listarItens() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/perfil/itens'),
      headers: await _getHeaders(),
    );
    final dados = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(dados['erro'] ?? 'Erro ao carregar itens.');
    }

    final lista = dados['itens'] as List;
    return lista
        .map((item) => ItemPerfil.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Equipa um item já desbloqueado pelo usuário logado.
  static Future<void> equiparItem(int idItem) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/perfil/itens/$idItem/equipar'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      final dados = jsonDecode(response.body);
      throw Exception(dados['erro'] ?? 'Erro ao equipar item.');
    }
  }
}
