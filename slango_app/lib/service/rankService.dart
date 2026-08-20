import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ResultadoRanking {
  final bool registrado;
  final double percentualAcerto;
  final int pontuacao;
  final String mensagem;

  ResultadoRanking({
    required this.registrado,
    required this.percentualAcerto,
    required this.pontuacao,
    required this.mensagem,
  });

  factory ResultadoRanking.fromJson(Map<String, dynamic> json) => ResultadoRanking(
        registrado: json['registrado'] ?? false,
        percentualAcerto: (json['percentualAcerto'] ?? 0).toDouble(),
        pontuacao: json['pontuacao'] ?? 0,
        mensagem: json['mensagem'] ?? '',
      );
}

class ItemRanking {
  final int posicao;
  final int idUsuario;
  final String nomeUsuario;
  final int melhorTempoMs;
  final int pontuacao;
  final String? urlAstronauta; // só vem preenchido pro top 3 (1º, 2º, 3º)

  ItemRanking({
    required this.posicao,
    required this.idUsuario,
    required this.nomeUsuario,
    required this.melhorTempoMs,
    required this.pontuacao,
    this.urlAstronauta,
  });

  factory ItemRanking.fromJson(Map<String, dynamic> json) => ItemRanking(
        posicao: json['posicao'],
        idUsuario: json['idUsuario'],
        nomeUsuario: json['nomeUsuario'] ?? 'Jogador',
        melhorTempoMs: json['melhorTempoMs'],
        pontuacao: json['pontuacao'],
        urlAstronauta: json['urlAstronauta'],
      );
}

class PosicaoUsuario {
  final int? posicao;
  final int? melhorTempoMs;
  final int totalJogadores;

  PosicaoUsuario({
    required this.posicao,
    required this.melhorTempoMs,
    required this.totalJogadores,
  });

  factory PosicaoUsuario.fromJson(Map<String, dynamic> json) => PosicaoUsuario(
        posicao: json['posicao'],
        melhorTempoMs: json['melhorTempoMs'],
        totalJogadores: json['totalJogadores'] ?? 0,
      );
}

class RankingServiceException implements Exception {
  final String mensagem;
  RankingServiceException(this.mensagem);
  @override
  String toString() => mensagem;
}

class RankingService {
  static const _storage = FlutterSecureStorage();

  static String get _baseUrl {
    final url = dotenv.env['API_URL']?.trim();
    if (url == null || url.isEmpty) {
      throw Exception('API_URL não definida.');
    }
    final baseSemBarra = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return baseSemBarra.endsWith('/api') ? baseSemBarra : '$baseSemBarra/api';
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<ResultadoRanking> registrarResultado({
    required String nomeDoMundo,
    required int tempoMs,
    required int pontuacaoFinal, // número de acertos (0–9)
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ranking'),
      headers: await _headers(),
      body: jsonEncode({
        'nomeDoMundo': nomeDoMundo,
        'tempoMs': tempoMs,
        'pontuacaoFinal': pontuacaoFinal,
      }),
    );

    final corpo = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw RankingServiceException(corpo['error'] ?? 'Não foi possível registrar seu resultado.');
    }
    return ResultadoRanking.fromJson(corpo);
  }

  static Future<List<ItemRanking>> buscarRankingGlobal({int limite = 500}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/ranking?limite=$limite'),
      headers: await _headers(),
    );

    final corpo = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw RankingServiceException(corpo['error'] ?? 'Não foi possível carregar o ranking.');
    }
    return (corpo['ranking'] as List).map((e) => ItemRanking.fromJson(e)).toList();
  }

  static Future<PosicaoUsuario> buscarMinhaPosicao() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/ranking/minha-posicao'),
      headers: await _headers(),
    );

    final corpo = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw RankingServiceException(corpo['error'] ?? 'Não foi possível carregar sua posição.');
    }
    return PosicaoUsuario.fromJson(corpo);
  }
}