import 'dart:convert';

import 'package:flutter/services.dart';

import 'falas_data.dart';
import 'mundo_slug.dart';

class FalasService {
  /// Falas exibidas quando o mundo não existe em lugar nenhum.
  static const List<String> falasPadrao = [
    'Bem-vindo ao SlanGO!',
    'Prepare-se para uma nova missão!',
  ];

  /// Recebe o slug do mundo (ex: 'jogos'), o nome completo ('Mundo K-Pop') ou
  /// variações com hífen/espaço/acento e devolve a lista de falas do mundo.
  ///
  /// Ordem de busca: JSON do bundle -> mapa embutido em Dart -> fallback.
  static Future<List<String>> obterFalas(String nomeMundo) async {
    final chave = normalizarMundo(nomeMundo);

    final doJson = await _falasDoJson(chave);
    if (doJson != null && doJson.isNotEmpty) return doJson;

    final embutidas = falasPorMundo[chave];
    if (embutidas != null && embutidas.isNotEmpty) return List.of(embutidas);

    return falasPadrao;
  }

  static Future<List<String>?> _falasDoJson(String chave) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/falas.json');

      final List<dynamic> dados = json.decode(jsonString) as List<dynamic>;

      final resultado = dados.cast<Map<String, dynamic>>().firstWhere(
        (item) {
          final id = normalizarMundo((item['id'] ?? '').toString());
          final mundo = normalizarMundo((item['mundo'] ?? '').toString());
          return id == chave || mundo == chave;
        },
        orElse: () => <String, dynamic>{},
      );

      final falas = resultado['falas'];
      if (falas is List && falas.isNotEmpty) {
        return falas.map((f) => f.toString()).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}