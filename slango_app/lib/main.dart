import 'package:flutter/material.dart';
import 'licao.dart';
import 'revisao.dart';
import 'mapa/mapa.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  dotenv.load(fileName: ".env").then((_) {
    runApp(const MyApp());
  });
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
      home: const MapaScreen(),
    );
  }
}

/// Cria uma transição entre as telas,
Route<T> criarRotaComFade<T>(Widget tela) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => tela,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

/// Controla a navegação entre a tela de lição e a tela de revisão final
class FluxoLicao extends StatefulWidget {
  const FluxoLicao({super.key});

  @override
  State<FluxoLicao> createState() => _FluxoLicaoState();
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
          criarRotaComFade(const TelaRevisaoFinal()),
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