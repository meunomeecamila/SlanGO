import 'dart:convert';

import 'package:flutter/services.dart';

import 'falas_data.dart';
import 'mundo_slug.dart';

class FalasService {
  /// Locale usado quando o locale pedido não está disponível.
  static const String _localeFallback = 'pt';

  /// Locales suportados pelas falas.
  static const List<String> _localesSuportados = ['pt', 'en', 'es'];

  /// Falas exibidas quando o mundo não existe em lugar nenhum, por locale.
  static const Map<String, List<String>> falasPadrao = {
    'pt': [
      'Bem-vindo ao SlanGO, {nome}!',
      'Prepare-se para uma nova missão!',
    ],
    'en': [
      'Welcome to SlanGO, {nome}!',
      'Get ready for a new mission!',
    ],
    'es': [
      '¡Bienvenido a SlanGO, {nome}!',
      '¡Prepárate para una nueva misión!',
    ],
  };

  /// Tratamento usado quando o usuário não tem nome definido, por locale.
  static const Map<String, String> _tratamentoPadraoPorLocale = {
    'pt': 'astronauta',
    'en': 'astronaut',
    'es': 'astronauta',
  };

  /// Normaliza o locale recebido (ex: 'pt_BR', 'pt-BR', 'PT') para uma das
  /// chaves suportadas ('pt', 'en', 'es'), caindo em [_localeFallback] se
  /// não reconhecer.
  static String _normalizarLocale(String? locale) {
    final codigo = (locale ?? '').trim().toLowerCase();
    if (codigo.isEmpty) return _localeFallback;
    final base = codigo.split(RegExp('[_-]')).first;
    return _localesSuportados.contains(base) ? base : _localeFallback;
  }

  static Future<List<String>> obterFalas(
    String nomeMundo, {
    String? nomeUsuario,
    String? locale,
  }) async {
    final chave = normalizarMundo(nomeMundo);
    final localeNormalizado = _normalizarLocale(locale);

    List<String> resultado;

    // 1) Mapa embutido em Dart — reflete edições imediatamente.
    final embutidas = _falasPorLocale(falasPorMundo[chave], localeNormalizado);
    if (embutidas != null && embutidas.isNotEmpty) {
      resultado = List.of(embutidas);
    } else {
      // 2) JSON do bundle (precisa de restart completo para atualizar).
      final doJson = await _falasDoJson(chave, localeNormalizado);
      // 3) Fallback genérico.
      resultado = (doJson != null && doJson.isNotEmpty)
          ? doJson
          : (falasPadrao[localeNormalizado] ?? falasPadrao[_localeFallback]!);
    }

    return _aplicarNome(resultado, nomeUsuario, localeNormalizado);
  }

  /// Escolhe a lista de falas do locale pedido dentro do mapa do mundo,
  /// caindo para [_localeFallback] se o locale pedido não existir.
  static List<String>? _falasPorLocale(
    Map<String, List<String>>? falasDoMundo,
    String locale,
  ) {
    if (falasDoMundo == null) return null;
    return falasDoMundo[locale] ?? falasDoMundo[_localeFallback];
  }

  /// Substitui `{nome}` pelo nome do usuário (ou pelo tratamento padrão do
  /// locale, ex.: "astronaut" em inglês, se vazio).
  static List<String> _aplicarNome(
    List<String> falas,
    String? nomeUsuario,
    String locale,
  ) {
    final nome = (nomeUsuario ?? '').trim();
    final tratamento = nome.isEmpty
        ? (_tratamentoPadraoPorLocale[locale] ??
            _tratamentoPadraoPorLocale[_localeFallback]!)
        : nome;
    return falas.map((f) => f.replaceAll('{nome}', tratamento)).toList();
  }

  static Future<List<String>?> _falasDoJson(String chave, String locale) async {
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
      if (falas is Map) {
        final porLocale = falas.cast<String, dynamic>();
        final lista = (porLocale[locale] ?? porLocale[_localeFallback]);
        if (lista is List && lista.isNotEmpty) {
          return lista.map((f) => f.toString()).toList();
        }
        return null;
      }
      // Compatibilidade com o formato antigo (lista simples, só em pt).
      if (falas is List && falas.isNotEmpty) {
        return falas.map((f) => f.toString()).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}