import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../licao_page.dart';
import '../data/falas_service.dart';
import '../data/mundo_assets.dart';
import '../data/mundo_slug.dart';
import 'package:slango_app/mapa/mapa.dart';

import 'dart:math';

class FundoEspacial extends StatelessWidget {
  const FundoEspacial({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(42);

    return IgnorePointer(
      child: Stack(
        children: List.generate(90, (index) {
          final size = random.nextDouble() * 3 + 1;

          return Positioned(
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            top: random.nextDouble() * MediaQuery.of(context).size.height,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(random.nextDouble() * .8 + .2),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TelaMundoDosJogos extends StatefulWidget {
  /// Slug do mundo (ex: 'jogos', 'geek') — vem do mapa.
  final String nomeMundo;

  const TelaMundoDosJogos({super.key, this.nomeMundo = 'jogos'});

  @override
  State<TelaMundoDosJogos> createState() => _TelaMundoDosJogosState();
}

class Missao extends TelaMundoDosJogos {
  const Missao({super.key, super.nomeMundo});
}

class _TelaMundoDosJogosState extends State<TelaMundoDosJogos> {
  final List<String> giriasDoJogo = ['MVP', 'CLUTCH', 'FEED', 'NOOB'];

  /// Slug canônico do mundo (ex: 'kpop'), derivado do nome recebido.
  String get _slugMundo => normalizarMundo(widget.nomeMundo);

  /// Título exibido no cabeçalho (ex: 'Mundo K-Pop').
  String get _tituloMundo => tituloDoMundo(widget.nomeMundo);

  // Falas carregadas dinamicamente de assets/json/falas.json.
  List<String> _falasDoMundo = [];
  bool _carregandoFalas = true;

  // Índice da fala atual exibida no balão.
  int _indiceFala = 0;

  @override
  void initState() {
    super.initState();
    _carregarFalas();
  }

  Future<void> _carregarFalas() async {
    final falas = await FalasService.obterFalas(_slugMundo);
    if (!mounted) return;
    setState(() {
      _falasDoMundo = falas;
      _indiceFala = 0;
      _carregandoFalas = false;
    });
  }

  /// Texto atual do balão (mensagem de carregamento enquanto busca o JSON).
  String get _textoDaFala {
    if (_carregandoFalas) return 'Carregando transmissão...';
    if (_falasDoMundo.isEmpty) return '';
    return _falasDoMundo[_indiceFala];
  }

  /// Só há próxima fala se não estivermos no último índice.
  bool get _temProximaFala =>
      !_carregandoFalas && _indiceFala < _falasDoMundo.length - 1;

  void _proximaFala() {
    if (!_temProximaFala) return;
    setState(() => _indiceFala++);
  }

  /// Só há fala anterior se não estivermos na primeira.
  bool get _temFalaAnterior => !_carregandoFalas && _indiceFala > 0;

  void _falaAnterior() {
    if (!_temFalaAnterior) return;
    setState(() => _indiceFala--);
  }

  /// Asset do ET do mundo atual (centralizado em mundo_assets.dart).
  String get _imagemDoEt => petDoMundo(widget.nomeMundo);

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
              colors: [Color(0xFF1A0F2E), Color(0xFF120B24), Color(0xFF0D0818)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                CabecalhoComTituloCentralizado(nomeMundo: _tituloMundo),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BalaoDeFala(
                          texto: _textoDaFala,
                          mostrarContinuar: _temProximaFala,
                          aoContinuar: _proximaFala,
                          mostrarVoltar: _temFalaAnterior,
                          aoVoltar: _falaAnterior,
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MapaScreen(),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(.45),
                                        blurRadius: 70,
                                        spreadRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(_imagemDoEt, height: 210),
                              ],
                            ),
                          ),
                        ),

                        ChipsDeGirias(girias: giriasDoJogo),
                        const SizedBox(height: 32),
                        BotaoIniciarMissao(
                          aoTocar: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LicaoPage(nomeMundo: widget.nomeMundo),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
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
                border: Border.all(
                  color: purpleAccent.withOpacity(0.7),
                  width: 1.5,
                ),
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

class BalaoDeFala extends StatelessWidget {
  /// Fala atual do ET (vem do falas.json do mundo).
  final String texto;

  /// Quando false, o botão "Continuar" não é renderizado (falas acabaram).
  final bool mostrarContinuar;
  final VoidCallback aoContinuar;

  /// Quando true, mostra o botão "Voltar" (há fala anterior).
  final bool mostrarVoltar;
  final VoidCallback? aoVoltar;

  const BalaoDeFala({
    super.key,
    required this.texto,
    required this.aoContinuar,
    this.mostrarContinuar = true,
    this.mostrarVoltar = false,
    this.aoVoltar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CustomPaint(
          painter: PintaPontaDoBalaoDeFala(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            decoration: BoxDecoration(
              color: const Color(0xFF241A3D),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6C4FC9), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (mostrarVoltar && aoVoltar != null)
                      BotaoVoltarFala(aoTocar: aoVoltar!)
                    else
                      Container(
                        width: 24,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4FC9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    if (mostrarContinuar) BotaoContinuar(aoTocar: aoContinuar),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BotaoContinuar extends StatelessWidget {
  final VoidCallback aoTocar;

  const BotaoContinuar({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: aoTocar,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C4FC9),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Continuar'),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 11),
        ],
      ),
    );
  }
}

/// Botão discreto para voltar à fala anterior do ET.
class BotaoVoltarFala extends StatelessWidget {
  final VoidCallback aoTocar;

  const BotaoVoltarFala({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: aoTocar,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFB9A6E8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 11),
          SizedBox(width: 4),
          Text('Voltar', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ChipsDeGirias extends StatelessWidget {
  final List<String> girias;

  const ChipsDeGirias({super.key, required this.girias});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: girias
            .map((giria) => ChipDeGiriaSemClique(texto: giria))
            .toList(),
      ),
    );
  }
}

class ChipDeGiriaSemClique extends StatelessWidget {
  final String texto;

  const ChipDeGiriaSemClique({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF241A3D),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF6C4FC9).withOpacity(0.7),
          width: 1.5,
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFFB9A6E8),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class BotaoIniciarMissao extends StatelessWidget {
  final VoidCallback aoTocar;

  const BotaoIniciarMissao({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: aoTocar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C5CE0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 6,
            shadowColor: const Color(0xFF7C5CE0).withOpacity(0.5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🚀', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'Iniciar Missão',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BotaoEmFormatoDePilula extends StatelessWidget {
  final Widget conteudo;
  final VoidCallback aoTocar;

  const BotaoEmFormatoDePilula({
    super.key,
    required this.conteudo,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF241A3D),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF6C4FC9).withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: conteudo,
      ),
    );
  }
}

class PintaPontaDoBalaoDeFala extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tintaDoBalao = Paint()
      ..color = const Color(0xFF6C4FC9)
      ..style = PaintingStyle.fill;

    final formaDaPonta = Path()
      ..moveTo(20, size.height)
      ..lineTo(36, size.height)
      ..lineTo(20, size.height + 16)
      ..close();

    canvas.drawPath(formaDaPonta, tintaDoBalao);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
