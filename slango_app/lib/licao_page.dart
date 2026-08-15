import 'package:flutter/material.dart';

import 'fase/fase.dart';
import 'quiz_page.dart'; // Certifique-se de que o enum ModoQuiz está neste arquivo
import 'service/MundoService.dart';

class LicaoPage extends StatefulWidget {
  final String nomeMundo;

  /// Rodada já carregada pela tela de Missão. Quando fornecida, a LicaoPage
  /// usa esses dados diretamente — garantindo que chips, lição e quiz
  /// mostrem exatamente as mesmas gírias, sem chamadas extras ao endpoint.
  final RodadaMundo? rodadaPrecarregada;

  /// Define se o quiz será Rankeado ou Casual. Padrão: Casual (normal).
  final ModoQuiz modo; 

  const LicaoPage({
    super.key,
    required this.nomeMundo,
    this.rodadaPrecarregada,
    this.modo = ModoQuiz.normal, 
  });

  @override
  State<LicaoPage> createState() => _LicaoPageState();
}

class _LicaoPageState extends State<LicaoPage> {
  late Future<RodadaMundo> _futureRodada;

  @override
  void initState() {
    super.initState();
    if (widget.rodadaPrecarregada != null) {
      _futureRodada = Future.value(widget.rodadaPrecarregada!);
    } else {
      _futureRodada = MundoService.buscarRodada(widget.nomeMundo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RodadaMundo>(
      future: _futureRodada,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C5CFF)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1F1035),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Erro ao carregar fases: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final rodada = snapshot.data;
        if (rodada == null || rodada.fases.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(
              child: Text(
                'Nenhuma fase encontrada.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        return QuizPage(
          nomeMundo: widget.nomeMundo,
          modo: widget.modo, 
          perguntasPrecarregadas: rodada.todasAsPerguntas,
          explicacoesPrecarregadas: rodada.fases,
        );
      },
    );
  }
}