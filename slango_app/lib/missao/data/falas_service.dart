import 'dart:convert';

import 'package:flutter/services.dart';

import 'falas_data.dart';
import 'mundo_slug.dart';

/// Serviço de falas do ET.
///
/// POR QUE SUAS EDIÇÕES NO JSON PODEM NÃO APARECER:
/// `assets/json/falas.json` é empacotado no bundle no momento do build. Um
/// *hot reload* (r) NÃO re-empacota assets — só um *restart completo* (flutter
/// run de novo) atualiza o JSON. Já `falas_data.dart` é código Dart puro,
/// então qualquer alteração nele aparece com hot reload/restart normal.
///
/// Por isso a ordem de busca é: mapa Dart (`falas_data.dart`) -> JSON do
/// bundle -> fallback genérico.
///
/// // Para adicionar mais falas, insira novas strings neste arquivo aqui:
/// //   lib/missao/data/falas_data.dart  (fonte de verdade, hot-reload OK)
/// //   assets/json/falas.json           (cópia opcional, exige restart)
class FalasService {
  /// Falas exibidas quando o mundo não existe em lugar nenhum.
  static const List<String> falasPadrao = [
    'Bem-vindo ao SlanGO!',
    'Prepare-se para uma nova missão!',
  ];

  /// Recebe o slug do mundo ('jogos'), o nome completo ('Mundo K-Pop') ou
  /// variações com hífen/espaço/acento e devolve a lista de falas do mundo.
  static Future<List<String>> obterFalas(String nomeMundo) async {
    final chave = normalizarMundo(nomeMundo);

    // 1) Mapa embutido em Dart — reflete edições imediatamente.
    final embutidas = falasPorMundo[chave];
    if (embutidas != null && embutidas.isNotEmpty) return List.of(embutidas);

    // 2) JSON do bundle (precisa de restart completo para atualizar).
    final doJson = await _falasDoJson(chave);
    if (doJson != null && doJson.isNotEmpty) return doJson;

    // 3) Fallback genérico.
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
