import 'dart:convert';

import 'package:flutter/services.dart';

class FalasService {
  static Future<String> obterFala(String nomeMundo) async {
    final String jsonString =
        await rootBundle.loadString('assets/json/falas.json');

    final List<dynamic> dados = json.decode(jsonString);

    final resultado = dados.firstWhere(
      (item) => item['mundo'] == nomeMundo,
      orElse: () => {
        'fala': 'Bem-vindo ao SlanGO! Prepare-se para uma nova missão!'
      },
    );

    return resultado['fala'];
  }
}