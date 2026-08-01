import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../fase/fase.dart';
import '../../licao_page.dart';
import '../../service/MundoService.dart';

class TelaMundoDosJogos extends StatefulWidget {
  final String nomeMundo;

  const TelaMundoDosJogos({super.key, required this.nomeMundo});

  @override
  State<TelaMundoDosJogos> createState() => _TelaMundoDosJogosState();
}

class Missao extends TelaMundoDosJogos {
  const Missao({super.key, required super.nomeMundo});
}

class _TelaMundoDosJogosState extends State<TelaMundoDosJogos> {
  late Future<RodadaMundo> _futureRodada;

  @override
  void initState() {
    super.initState();
    _futureRodada = MundoService.buscarRodada(widget.nomeMundo);
  }

  void _iniciarMissao(RodadaMundo rodada) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LicaoPage(
          nomeMundo: widget.nomeMundo,
          rodadaPrecarregada: rodada,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: GoogleFonts.poppins(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A0F2E),
                Color(0xFF120B24),
                Color(0xFF0D0818),
              ],
            ),
          ),
          child: SafeArea(
            child: FutureBuilder<RodadaMundo>(
              future: _futureRodada,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C5CE0)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Erro ao carregar missão:\n${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final rodada = snapshot.data;
                if (rodada == null || rodada.fases.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma gíria encontrada para este mundo.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final giriasDoJogo = rodada.fases
                    .map((f) => f.giria.toUpperCase())
                    .toSet()
                    .toList();

                return Column(
                  children: [
                    CabecalhoComTituloCentralizado(nomeMundo: rodada.nome),
                    const SizedBox(height: 24),
                    const PlanetaEFoguete(),
                    const Spacer(),
                    const BalaoDeFala(),
                    const SizedBox(height: 24),
                    const AvatarDoAlien(),
                    const SizedBox(height: 24),
                    ChipsDeGirias(girias: giriasDoJogo),
                    const SizedBox(height: 16),
                    BotaoIniciarMissao(
                      aoTocar: () => _iniciarMissao(rodada),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CabecalhoComTituloCentralizado extends StatelessWidget {
  final String nomeMundo;

  const CabecalhoComTituloCentralizado({super.key, required this.nomeMundo});

  static const Color purpleAccent = Color(0xFF6C4FC9);
  static const Color purpleLight = Color(0xFFB9A6E8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF241A3D),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: purpleAccent.withOpacity(0.7), width: 1.5),
              ),
              child: Text(
                nomeMundo,
                style: const TextStyle(
                  color: purpleLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: BotaoEmFormatoDePilula(
              aoTocar: () => Navigator.of(context).maybePop(),
              conteudo: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Color(0xFFB9A6E8), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Mapa',
                    style: TextStyle(
                      color: Color(0xFFB9A6E8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanetaEFoguete extends StatelessWidget {
  const PlanetaEFoguete({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: 0.75,
          child: Image.asset(
            'images/jogos.png',
            width: 112,
            height: 112,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}