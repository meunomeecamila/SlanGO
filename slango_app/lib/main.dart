import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'licao_page.dart';
import 'revisao.dart';
import 'mapa/mapa.dart';
import 'inicio/inicio.dart';
import 'final/TelaCertificado.dart';
import 'mapa/data/mundos_mock.dart';
import 'l10n/l10n.dart';
import 'l10n/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localeController = LocaleController();

  @override
  void initState() {
    super.initState();
    _localeController.load();
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _localeController,
      builder: (context, _) => LocaleControllerScope(
        controller: _localeController,
        child: MaterialApp(
      locale: _localeController.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1F1035),
        canvasColor: const Color(0xFF1F1035),
      ),

      home: const InicioScreen(),

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/licao':
            final nomeMundoLicao = settings.arguments as String? ?? '';
            return criarRotaComFade(
              LicaoPage(nomeMundo: nomeMundoLicao),
            );
          default:
            return null;
        }
      },
        ),
      ),
    );
  }
}

/// Cria uma transição entre as telas
Route<T> criarRotaComFade<T>(Widget tela) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => tela,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

/// Tela de revisão final
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
      opcoes: const [
        'Positiva 😊',
        'Negativa 😠',
        'Depende do contexto 🤔',
      ],
      opcaoSelecionada: opcaoSelecionada,
      onSelecionarOpcao: (valor) {
        setState(() => opcaoSelecionada = valor);
      },
      fraseIncompleta: '"Aquele jogador fez um {} incrível!"',
      palavrasOpcoes: const [
        'CLUTCH',
        'NOOB',
        'SMURF',
        'FEED',
      ],
      palavraSelecionada: palavraSelecionada,
      onSelecionarPalavra: (valor) {
        setState(() => palavraSelecionada = valor);
      },
      onConcluir: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
