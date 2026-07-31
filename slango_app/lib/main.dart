import 'package:flutter/material.dart';
import 'licao.dart';
import 'revisao.dart';
import 'mapa/mapa.dart';
import 'inicio/inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1F1035),
        canvasColor: const Color(0xFF1F1035),
      ),
      home: const InicioScreen(),
    );
  }
}

/// Controla a navegação entre a tela de lição e a tela de revisão final
class FluxoLicao extends StatefulWidget {
  const FluxoLicao({super.key});

  @override
  State<FluxoLicao> createState() => _FluxoLicaoState();
}

Route<T> criarRotaSemAnimacao<T>(Widget tela) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => tela,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class _FluxoLicaoState extends State<FluxoLicao> {
  int cntCorreto = 0;
  int cntErrado = 0;

  @override
  Widget build(BuildContext context) {
    return SlangQuizScreen(
      palavra: 'SMURF',
      classe: 'Substantivo',
      significado:
          'Jogador experiente que usa conta de nível baixo para dominar partidas mais fáceis.',
      exemplo: '"Cuidado com esse player, ele é um smurf clássico!"',
      usageHighlight: 'Esse cara é um SMURF — ele destruiu todo mundo!',
      cntCorreto: cntCorreto,
      cntErrado: cntErrado,
      onClose: () {
        Navigator.of(context).maybePop();
      },
      onContinue: () {
        // Ao terminar a lição, navega para a tela de revisão final.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TelaRevisaoFinal()),
        );
      },
    );
  }
}

/// Tela de revisão final com controle próprio de estado
/// (qual opção e qual palavra foram selecionadas).
class TelaRevisaoFinal extends StatefulWidget {
  const TelaRevisaoFinal({super.key});

  @override
  State<TelaRevisaoFinal> createState() => _TelaRevisaoFinalState();
}

class _TelaRevisaoFinalState extends State<TelaRevisaoFinal> {
  String? opcaoSelecionada;
  String? palavraSelecionada;

  @override
  Widget build(BuildContext context) {
    return RevisaoFinalScreen(
      pergunta: 'A gíria "CLUTCH" é uma expressão...',
      opcoes: const ['Positiva 😊', 'Negativa 😠', 'Depende do contexto 🤔'],
      opcaoSelecionada: opcaoSelecionada,
      onSelecionarOpcao: (valor) {
        setState(() => opcaoSelecionada = valor);
      },
      fraseIncompleta: '"Aquele jogador fez um {} incrível!"',
      palavrasOpcoes: const ['CLUTCH', 'NOOB', 'SMURF', 'FEED'],
      palavraSelecionada: palavraSelecionada,
      onSelecionarPalavra: (valor) {
        setState(() => palavraSelecionada = valor);
      },
      onConcluir: () {
        // voltar para a tela inicial do app.
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}