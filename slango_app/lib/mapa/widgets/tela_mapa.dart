import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../widgets/background_espaco.dart';
import '../widgets/mapa_header.dart';
import '../widgets/planeta_widget.dart';
import '../widgets/navegacao_mundos.dart';
import '../widgets/card_mundo.dart';
import '../../shared/widgets/particulas_fundo.dart';
import '../../perfil/perfil_screen.dart';
import '../../../perfil/ranking/rankingScreen.dart'; 

// Permite arrastar o PageView com mouse, trackpad e stylus além do touch.
// Necessário no Flutter Web, onde por padrão só "touch" gera drag.
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class TelaMapa extends StatefulWidget {
  final List<Mundo> mundos;
  final void Function(Mundo mundo)? onExplorar;

  const TelaMapa({super.key, required this.mundos, this.onExplorar});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  int paginaAtual = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void irParaMundoAnterior() {
    int anterior = paginaAtual - 1;
    if (anterior < 0) anterior = widget.mundos.length - 1;

    _pageController.animateToPage(
      anterior,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void irParaProximoMundo() {
    int proximo = paginaAtual + 1;
    if (proximo >= widget.mundos.length) proximo = 0;

    _pageController.animateToPage(
      proximo,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void abrirPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PerfilScreen(
          totalMundos: 0,
          totalGirias: 0,
          totalCertificados: 0,
        ),
      ),
    );
  }

  void abrirRanking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RankingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mundoAtual = widget.mundos[paginaAtual];

    return Scaffold(
      body: BackgroundEspaco(
        child: ParticulasFundo(
          quantidade: 60,
          corParticulas: const Color(0xFF9C8CF0),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    MapaHeader(
                      onPerfilTap: abrirPerfil,
                      onRankingTap: abrirRanking,
                    ),
                    const SizedBox(height: 10),

                    // Carrossel de Planetas com altura ideal para não cortar a arte
                    SizedBox(
                      height: 335,
                      child: ScrollConfiguration(
                        behavior: _AppScrollBehavior(),
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() => paginaAtual = index);
                          },
                          itemCount: widget.mundos.length,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double scale = 1.0;
                                if (_pageController.position.haveDimensions) {
                                  scale = _pageController.page! - index;
                                  scale = (1 - (scale.abs() * 0.25)).clamp(
                                    0.7,
                                    1.0,
                                  );
                                } else {
                                  scale = paginaAtual == index ? 1.0 : 0.7;
                                }

                                return Center(
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Opacity(
                                      opacity: scale.clamp(0.4, 1.0),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: PlanetaWidget(mundo: widget.mundos[index]),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Setas e Indicadores ajustados
                    NavegacaoMundos(
                      paginaAtual: paginaAtual,
                      totalPaginas: widget.mundos.length,
                      onAnterior: irParaMundoAnterior,
                      onProximo: irParaProximoMundo,
                    ),

                    const SizedBox(height: 16),

                    // Card do Mundo Atual
                    CardMundo(
                      mundo: mundoAtual,
                      onExplorar: () => widget.onExplorar?.call(mundoAtual),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}