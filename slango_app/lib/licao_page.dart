import 'package:flutter/material.dart';

import 'fase/fase.dart';
import 'licao.dart';
import 'missao/data/mundo_assets.dart';
import 'quiz_page.dart';
import 'service/MundoService.dart';

class LicaoPage extends StatefulWidget {
  final String nomeMundo;

  /// Rodada já carregada pela tela de Missão. Quando fornecida, a LicaoPage
  /// usa esses dados diretamente — garantindo que chips, lição e quiz
  /// mostrem exatamente as mesmas gírias, sem chamadas extras ao endpoint.
  final RodadaMundo? rodadaPrecarregada;

  const LicaoPage({
    super.key,
    required this.nomeMundo,
    this.rodadaPrecarregada,
  });

  @override
  State<LicaoPage> createState() => _LicaoPageState();
}

class _LicaoPageState extends State<LicaoPage> {
  late Future<RodadaMundo> _futureRodada;
  int _indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    _futureRodada = MundoService.buscarRodada(widget.nomeMundo);
  }

  void _avancar(RodadaMundo rodada) {
    final fases = rodada.fases;
    if (_indiceAtual < fases.length - 1) {
      setState(() {
        _indiceAtual++;
      });
    } else {
      // Passa as perguntas já carregadas para o QuizPage — sem nova requisição.
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => QuizPage(
            nomeMundo: widget.nomeMundo,
            perguntasPrecarregadas: rodada.todasAsPerguntas,
          ),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
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
            body: Center(child: CircularProgressIndicator()),
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

        final fase = rodada.fases[_indiceAtual];

        return SlangQuizScreen(
          palavra: fase.giria,
          classe: fase.classe ?? '',
          significado: fase.explicacao,
          exemplo: fase.exemplo,
          usageHighlight: fase.exemplo,
          // ET do mundo atual (cai em 'images/avatar.png' se não houver).
          avatar: petDoMundo(widget.nomeMundo),
          progresso: (_indiceAtual + 1) / rodada.fases.length,
          onClose: () => Navigator.pop(context),
          onContinue: () => _avancar(rodada),
        );
      },
    );
  }
}
