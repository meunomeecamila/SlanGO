import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/sugestao_giria.dart';

/// Serviço HTTP para sugestões de gírias. Mantém o mesmo padrão de
/// `_baseUrl`/token dos demais services do app (UsuarioService, MundoService).
class SugestaoService {
  static const _storage = FlutterSecureStorage();

  static String get _baseUrl {
    final url = dotenv.env['API_URL']?.trim();
    if (url == null || url.isEmpty) {
      throw Exception(
        'API_URL não definida. Configure a variável API_URL no arquivo .env.',
      );
    }

    final baseSemBarra =
        url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return baseSemBarra.endsWith('/api') ? baseSemBarra : '$baseSemBarra/api';
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _decodeBody(http.Response resp) {
    if (resp.body.isEmpty) return {};
    try {
      return jsonDecode(resp.body);
    } catch (_) {
      return {};
    }
  }

  // ── Usuário comum ────────────────────────────────────────

  /// Envia uma nova sugestão. Retorna a sugestão criada.
  static Future<SugestaoGiria> enviar({
    required String nome,
    required String significado,
    required String exemplo,
    required String impacto,
    required String impactoMotivo,
    required String classeGramatical,
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/sugestoes'),
      headers: await _headers(),
      body: jsonEncode({
        'nome': nome,
        'significado': significado,
        'exemplo': exemplo,
        'impacto': impacto,
        'impacto_motivo': impactoMotivo,
        'classe_gramatical': classeGramatical,
      }),
    );

    final dados = _decodeBody(resp);
    if (resp.statusCode == 201) {
      return SugestaoGiria.fromJson(dados['sugestao'] as Map<String, dynamic>);
    }
    throw Exception(dados['erro'] ?? 'Erro ao enviar sugestão.');
  }

  /// Histórico do usuário logado — todas as sugestões que ele enviou.
  static Future<List<SugestaoGiria>> minhas() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/sugestoes/minhas'),
      headers: await _headers(),
    );

    final dados = _decodeBody(resp);
    if (resp.statusCode == 200) {
      final lista = (dados['sugestoes'] as List?) ?? const [];
      return lista
          .map((e) => SugestaoGiria.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(dados['erro'] ?? 'Erro ao carregar histórico.');
  }

  // ── Admin ────────────────────────────────────────────────

  /// Lista todas as sugestões pendentes de moderação (apenas admin).
  static Future<List<SugestaoGiria>> pendentes() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/sugestoes/pendentes'),
      headers: await _headers(),
    );

    final dados = _decodeBody(resp);
    if (resp.statusCode == 200) {
      final lista = (dados['sugestoes'] as List?) ?? const [];
      return lista
          .map((e) => SugestaoGiria.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (resp.statusCode == 403) {
      throw Exception('Apenas administradores acessam esta lista.');
    }
    throw Exception(dados['erro'] ?? 'Erro ao carregar sugestões pendentes.');
  }

  /// Aprova ou recusa uma sugestão. `descricaoAdm` é obrigatória.
  static Future<SugestaoGiria> moderar({
    required String idSugestao,
    required StatusSugestao decisao,
    required String descricaoAdm,
  }) async {
    if (decisao == StatusSugestao.pendente) {
      throw Exception('Decisão deve ser APROVADO ou REJEITADO.');
    }
    if (descricaoAdm.trim().isEmpty) {
      throw Exception('Preencha a observação antes de confirmar.');
    }

    final resp = await http.patch(
      Uri.parse('$_baseUrl/sugestoes/$idSugestao/moderar'),
      headers: await _headers(),
      body: jsonEncode({
        'status': decisao.valorBackend,
        'descricao_adm': descricaoAdm.trim(),
      }),
    );

    final dados = _decodeBody(resp);
    if (resp.statusCode == 200) {
      return SugestaoGiria.fromJson(dados['sugestao'] as Map<String, dynamic>);
    }
    throw Exception(dados['erro'] ?? 'Erro ao moderar sugestão.');
  }
}
