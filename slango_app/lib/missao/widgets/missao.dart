import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../licao_page.dart';
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

  // TODO: ALTERAR AQUI — adicione novas falas do ET nesta lista (uma string por
  // balão). O botão "Continuar" avança para a próxima fala.
  final List<String> falasDoEt = [
    'Olá, astronauta! Bem-vindo ao Mundo dos Games 🎮',
    'Em breve...',
    
  ];

  // Índice da fala atual exibida no balão.
  int _indiceFala = 0;

  void _proximaFala() {
    setState(() {
      if (_indiceFala < falasDoEt.length - 1) {
        _indiceFala++;
      } else {
        _indiceFala = 0; // volta para a primeira fala
      }
    });
  }

  // TODO: CAMINHO DA IMAGEM DO ET — troque/adicione aqui o asset do ET de cada
  // mundo. A chave é o id do mundo (mesmo id de mundos_mock.dart) e o valor é o
  // caminho da imagem dentro de images/planets_pets/.
  static const Map<String, String> _imagensDosEts = {
    'jogos': 'images/planets_pets/jogo_pet.png',
    'kpop': 'images/planets_pets/kpop_pet.png',
    'maquiagem': 'images/planets_pets/maquiagem_pet.png',
    'pop': 'images/planets_pets/pop_pet.png',
    'antigo': 'images/planets_pets/antigo_pet.png',
    'cotidiano': 'images/planets_pets/cotidiano_pet.png',
    'esportes': 'images/planets_pets/esporte_pet.png',
    'geek': 'images/planets_pets/geek_pet.png',
    'redessociais': 'images/planets_pets/redessociais_pet.png',
    'relacionamentos': 'images/planets_pets/relacionamentos_pet.png',
  };

  /// Asset do ET do mundo atual (cai no ET dos jogos se o mundo não estiver no mapa acima).
  String get _imagemDoEt =>
      _imagensDosEts[widget.nomeMundo] ?? 'images/planets_pets/jogo_pet.png';

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
                const CabecalhoComTituloCentralizado(nomeMundo: 'Mundo Jogos'),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BalaoDeFala(
                          texto: falasDoEt[_indiceFala],
                          aoContinuar: _proximaFala,
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
  /// Fala atual do ET (vem da lista falasDoEt).
  final String texto;
  final VoidCallback aoContinuar;

  const BalaoDeFala({
    super.key,
    required this.texto,
    required this.aoContinuar,
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
                    Container(
                      width: 24,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4FC9),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    BotaoContinuar(aoTocar: aoContinuar),
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
