import 'package:flutter/material.dart';

import 'fase/fase.dart';
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

  @override
  void initState() {
    super.initState();
    // CORREÇÃO: Utiliza os dados pré-carregados se existirem (evita chamada extra na API)
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

        // As telas de explicação NÃO fazem mais parte do fluxo padrão:
        // elas são exibidas pelo QuizPage apenas quando o jogador erra
        // alguma questão daquela gíria. Por isso entramos direto no quiz,
        // passando as explicações já carregadas (rodada.fases).
        return QuizPage(
          nomeMundo: widget.nomeMundo,
          perguntasPrecarregadas: rodada.todasAsPerguntas,
          explicacoesPrecarregadas: rodada.fases,
        );
      },
    );
  }
}