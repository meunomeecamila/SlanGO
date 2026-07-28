import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../fase/fase.dart';
import '../mapa/models/mundo.dart';

class MundoService {
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

  static Future<List<Mundo>> listarMundos() async {
    final uri = Uri.parse('$_baseUrl/mundos');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao listar mundos (status ${response.statusCode}): ${response.body}',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    final nomes =
        (json['mundos'] as List<dynamic>).map((e) => e as String).toList();

    return nomes.map((nome) => Mundo.fromNomeCapitalizado(nome)).toList();
  }

  static Future<RodadaMundo> buscarRodada(String nomeMundo) async {
    final uri = Uri.parse('$_baseUrl/mundos/$nomeMundo/fases');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao buscar rodada do mundo "$nomeMundo" '
        '(status ${response.statusCode}): ${response.body}',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    return RodadaMundo.fromJson(json);
  }

  static Future<List<Fase>> buscarFases(String nomeMundo) async {
    final rodada = await buscarRodada(nomeMundo);
    return rodada.fases;
  }

  static Future<Map<String, dynamic>> validarResultado(
    int pontuacaoFinal,
  ) async {
    final uri = Uri.parse('$_baseUrl/mundos/resultado');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pontuacaoFinal': pontuacaoFinal}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao validar resultado (status ${response.statusCode}): '
        '${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}