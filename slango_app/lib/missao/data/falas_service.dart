import 'dart:convert';

import 'package:flutter/services.dart';

import 'falas_data.dart';
import 'mundo_slug.dart';

class FalasService {
  /// Falas exibidas quando o mundo não existe em lugar nenhum.
  static const List<String> falasPadrao = [
    'Bem-vindo ao SlanGO, {nome}!',
    'Prepare-se para uma nova missão!',
  ];

  static Future<List<String>> obterFalas(
    String nomeMundo, {
    String? nomeUsuario,
  }) async {
    final chave = normalizarMundo(nomeMundo);

    List<String> resultado;

    // 1) Mapa embutido em Dart — reflete edições imediatamente.
    final embutidas = falasPorMundo[chave];
    if (embutidas != null && embutidas.isNotEmpty) {
      resultado = List.of(embutidas);
    } else {
      // 2) JSON do bundle (precisa de restart completo para atualizar).
      final doJson = await _falasDoJson(chave);
      // 3) Fallback genérico.
      resultado = (doJson != null && doJson.isNotEmpty) ? doJson : falasPadrao;
    }

    return _aplicarNome(resultado, nomeUsuario);
  }

  /// Substitui `{nome}` pelo nome do usuário (ou por "astronauta" se vazio).
  static List<String> _aplicarNome(List<String> falas, String? nomeUsuario) {
    final nome = (nomeUsuario ?? '').trim();
    final tratamento = nome.isEmpty ? 'astronauta' : nome;
    return falas.map((f) => f.replaceAll('{nome}', tratamento)).toList();
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