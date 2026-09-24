import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../fase/fase.dart';

class ExigeContaException implements Exception {
  final String mensagem;
  ExigeContaException(this.mensagem);

  @override
  String toString() => mensagem;
}

class MundoService {
  static const _storage = FlutterSecureStorage();

  static String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL não definida.');
    }
    return url;
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'token');

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static void _verificarResposta(http.Response response) {
    if (response.statusCode == 403) {
      final dados = jsonDecode(response.body);
      throw ExigeContaException(dados['erro'] ?? 'Crie uma conta para jogar.');
    }
  }

  static Future<List<String>> listarMundos() async {
    final uri = Uri.parse('$_baseUrl/mundos');

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar mundos: ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse is Map<String, dynamic> && jsonResponse['mundos'] is List) {
      return List<String>.from(jsonResponse['mundos']);
    }
    return [];
  }

  // Cache curto do progresso por idioma, evitando repetir a mesma requisição
  // toda vez que o mapa/perfil é reconstruído. Limpo ao salvar um resultado.
  static final Map<String, List<Map<String, dynamic>>> _cacheProgresso = {};
  static final Map<String, DateTime> _cacheProgressoHora = {};
  static final Map<String, Future<List<Map<String, dynamic>>>> _emAndamento = {};
  static const _validadeCache = Duration(minutes: 2);

  static void limparCacheProgresso() {
    _cacheProgresso.clear();
    _cacheProgressoHora.clear();
  }

  static Future<List<Map<String, dynamic>>> obterProgressoMundos({
    String idioma = 'pt',
    bool forcar = false,
  }) async {
    final hora = _cacheProgressoHora[idioma];
    if (!forcar &&
        hora != null &&
        DateTime.now().difference(hora) < _validadeCache) {
      return _cacheProgresso[idioma]!;
    }
    // Se já existe a mesma requisição rodando, reaproveita.
    final pendente = _emAndamento[idioma];
    if (pendente != null) return pendente;

    final futuro = _buscarProgressoMundos(idioma);
    _emAndamento[idioma] = futuro;
    try {
      final dados = await futuro;
      _cacheProgresso[idioma] = dados;
      _cacheProgressoHora[idioma] = DateTime.now();
      return dados;
    } finally {
      _emAndamento.remove(idioma);
    }
  }

  static Future<List<Map<String, dynamic>>> _buscarProgressoMundos(
    String idioma,
  ) async {
    final uri = Uri.parse('$_baseUrl/mundos/progresso').replace(
      queryParameters: {'idioma': idioma},
    );

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    _verificarResposta(response);

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

  static Future<RodadaMundo> buscarRodada(
    String nomeMundo, {
    String idioma = 'pt',
  }) async {
    final uri = Uri.parse('$_baseUrl/mundos/$nomeMundo/fases').replace(
      queryParameters: {'idioma': idioma},
    );

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    _verificarResposta(response);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar rodada: ${response.body}');
    }

    return RodadaMundo.fromJson(jsonDecode(response.body));
  }

  static Future<Map<String, dynamic>> validarResultado({
    required String nomeDoMundo,
    required int pontuacaoFinal,
    required List<dynamic> girias, // Agora recebe a lista de IDs
    String idioma = 'pt',
  }) async {
    final uri = Uri.parse('$_baseUrl/mundos/resultado');

    final headers = await _getHeaders();
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'nomeDoMundo': nomeDoMundo,
        'pontuacaoFinal': pontuacaoFinal,
        'girias': girias, 
        'idioma': idioma,
      }),
    );

    _verificarResposta(response);
    limparCacheProgresso();

    if (response.statusCode != 200) {
      throw Exception('Falha ao validar resultado: ${response.body}');
    }

    return jsonDecode(response.body);
  }

  static Future<List<Map<String, dynamic>>> buscarGiriasAprendidas(
    String nomeMundo,
    {String idioma = 'pt'}
  ) async {
    final uri = Uri.parse('$_baseUrl/mundos/$nomeMundo/aprendidas').replace(
      queryParameters: {'idioma': idioma},
    );

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    _verificarResposta(response);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar gírias aprendidas: ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);

    // Defensivo: aceita tanto { girias: [...] } quanto array direto,
    // seguindo o mesmo padrão usado nos outros métodos deste service.
    if (jsonResponse is Map<String, dynamic> && jsonResponse['girias'] is List) {
      return List<Map<String, dynamic>>.from(jsonResponse['girias']);
    }
    if (jsonResponse is List) {
      return List<Map<String, dynamic>>.from(jsonResponse);
    }
    return [];
  }

  static Future<Map<String, dynamic>> progressoMundo(
    String nomeDoMundo, {
    String idioma = 'pt',
  }) async {
    final uri = Uri.parse('$_baseUrl/mundos/$nomeDoMundo/progresso').replace(
      queryParameters: {'idioma': idioma},
    );

    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);

    _verificarResposta(response);

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar progresso do mundo: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}