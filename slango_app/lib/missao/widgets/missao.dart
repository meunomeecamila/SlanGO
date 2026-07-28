import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class TelaMundoDosJogos extends StatefulWidget {
  const TelaMundoDosJogos({super.key});

  @override
  State<TelaMundoDosJogos> createState() => _TelaMundoDosJogosState();
}

class Missao extends TelaMundoDosJogos {
  const Missao({super.key});
}

class _TelaMundoDosJogosState extends State<TelaMundoDosJogos> {
  final List<String> giriasDoJogo = ['MVP', 'CLUTCH', 'FEED', 'NOOB'];

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
          child: Column(
            children: [
              const CabecalhoComTituloCentralizado(nomeMundo: 'Mundo Jogos'),
              const SizedBox(height: 24),
              PlanetaEFoguete(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BalaoDeFala(),
                      const SizedBox(height: 24),
                      AvatarDoAlien(),
                      const SizedBox(height: 24),
                      ChipsDeGirias(girias: giriasDoJogo),
                      const SizedBox(height: 32),
                      BotaoIniciarMissao(
                        aoTocar: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FluxoLicao(),
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

class BalaoDeFala extends StatelessWidget {
  const BalaoDeFala({super.key});

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
                const Text(
                  'Olá, astronauta! Bem-vindo ao Mundo dos Games 🎮',
                  style: TextStyle(
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
                    BotaoContinuar(),
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
  const BotaoContinuar({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C4FC9),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
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

class AvatarDoAlien extends StatelessWidget {
  const AvatarDoAlien({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3D2B6B), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'images/avatar.png',
            fit: BoxFit.contain,
          ),
        ),
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
        children: girias.map((giria) => ChipDeGiriaSemClique(texto: giria)).toList(),
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
        border: Border.all(color: const Color(0xFF6C4FC9).withOpacity(0.7), width: 1.5),
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
          border: Border.all(color: const Color(0xFF6C4FC9).withOpacity(0.7), width: 1.5),
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