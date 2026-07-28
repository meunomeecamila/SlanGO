import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../widgets/background_espaco.dart';
import '../widgets/mapa_header.dart';
import '../widgets/planeta_widget.dart';
import '../widgets/navegacao_mundos.dart';
import '../widgets/card_mundo.dart';

class TelaMapa extends StatefulWidget {
  final List<Mundo> mundos;

  const TelaMapa({
    super.key,
    required this.mundos,
  });

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  int paginaAtual = 0;

  void irParaMundoAnterior() {
    if (paginaAtual > 0) {
      setState(() => paginaAtual--);
    }
  }

  void irParaProximoMundo() {
    if (paginaAtual < widget.mundos.length - 1) {
      setState(() => paginaAtual++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mundoAtual = widget.mundos[paginaAtual];

    return Scaffold(
      body: BackgroundEspaco(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const MapaHeader(),
                  const SizedBox(height: 20),
                  PlanetaWidget(mundo: mundoAtual),
                  const SizedBox(height: 28),
                  NavegacaoMundos(
                    paginaAtual: paginaAtual,
                    totalPaginas: widget.mundos.length,
                    onAnterior: irParaMundoAnterior,
                    onProximo: irParaProximoMundo,
                  ),
                  const SizedBox(height: 20),
                  CardMundo(
                    mundo: mundoAtual,
                    onExplorar: () {},
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}