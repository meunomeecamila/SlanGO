import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shared/widgets/fundo_espacial.dart';

class SlangQuizScreen extends StatelessWidget {
  final String palavra; // giria
  final String classe; // classe gramatical
  final String significado;
  final String exemplo;
  final String usageHighlight;
  final int cntCorreto;
  final int cntErrado;
  final double progresso; // barra de progresso
  final String avatar; // caminho da imagem do personagem
  final VoidCallback onClose;
  final VoidCallback onContinue;

  const SlangQuizScreen({
    super.key,
    required this.palavra,
    required this.classe,
    required this.significado,
    required this.exemplo,
    required this.usageHighlight,
    required this.onClose,
    required this.onContinue,
    this.cntCorreto = 0,
    this.cntErrado = 0,
    this.progresso = 0.0,
    this.avatar = 'images/avatar.png',
  });

  static const Color bgTop = Color(0xFF130A24);
  static const Color bgBottom = Color(0xFF1F1035);
  static const Color cardColor = Color(0xFF2A1B47);
  static const Color cardColorDark = Color(0xFF241640);
  static const Color purpleAccent = Color(0xFF7C5CFF);
  static const Color purpleLight = Color(0xFFB9A6FF);
  static const Color green = Color(0xFF4ADE80);
  static const Color red = Color(0xFFF87171);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.9, 1.25);
    final double heightScale = (size.height / 844).clamp(0.85, 1.35);

    return Scaffold(
      backgroundColor: bgBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: FundoEspacial()),
            SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 12 * heightScale),
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 28 * heightScale),
                        Text(
                          'IDENTIFIQUE O SIGNIFICADO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: purpleLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 13 * scale,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 18 * heightScale),
                        Text(
                          palavra.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.alfaSlabOne(
                            color: Colors.white,
                            fontSize: 46 * scale,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                color: purpleAccent.withOpacity(0.6),
                                blurRadius: 6 * scale,
                              ),
                              Shadow(
                                color: purpleAccent.withOpacity(0.45),
                                blurRadius: 14 * scale,
                              ),
                              Shadow(
                                color: purpleAccent.withOpacity(0.3),
                                blurRadius: 24 * scale,
                              ),
                              Shadow(
                                color: purpleLight.withOpacity(0.2),
                                blurRadius: 36 * scale,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8 * heightScale),
                        Text(
                          classe,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: purpleLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 14 * scale,
                          ),
                        ),
                        SizedBox(height: 28 * heightScale),
                        _buildMeaningRow(scale),
                        SizedBox(height: 22 * heightScale),
                        _buildExampleCard(scale),
                        SizedBox(height: 28 * heightScale),
                      ],
                    ),
                  ),
                ),
                _buildContinueButton(scale),
                SizedBox(height: 16 * heightScale),
              ],
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: onClose,
          child: const Icon(Icons.close, color: Colors.white70, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progresso.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: cardColor,
              valueColor: const AlwaysStoppedAnimation<Color>(purpleAccent),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Row(
          children: [
            const Icon(Icons.check, color: green, size: 18),
            const SizedBox(width: 4),
            Text('$cntCorreto',
                style: const TextStyle(
                    color: green, fontWeight: FontWeight.bold)),
            const SizedBox(width: 14),
            const Icon(Icons.close, color: red, size: 18),
            const SizedBox(width: 4),
            Text('$cntErrado',
                style: const TextStyle(
                    color: red, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildMeaningRow(double scale) {
    final double avatarSize = 64 * scale;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: purpleAccent.withOpacity(0.6)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            avatar,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.face, color: Colors.white54),
          ),
        ),
        SizedBox(width: 14 * scale),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16 * scale),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5 * scale,
                  height: 1.35,
                ),
                children: [
                  const TextSpan(
                    text: 'Significado: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: significado),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleCard(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18 * scale),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Exemplo de uso:',
            style: TextStyle(
              color: purpleLight,
              fontWeight: FontWeight.bold,
              fontSize: 14 * scale,
            ),
          ),
          SizedBox(height: 8 * scale),
          Text(
            exemplo,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 15 * scale,
              height: 1.35,
            ),
          ),
          SizedBox(height: 16 * scale),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14 * scale),
            decoration: BoxDecoration(
              color: cardColorDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Identifique o significado',
                      style: TextStyle(
                        color: purpleLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 13 * scale,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_downward,
                        color: purpleLight, size: 16 * scale),
                  ],
                ),
                SizedBox(height: 6 * scale),
                Text(
                  usageHighlight,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5 * scale,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(double scale) {
    return SizedBox(
      width: double.infinity,
      height: 58 * scale,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: purpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Entendi!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16 * scale,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Exemplo de uso da tela.
class SlangQuizExample extends StatelessWidget {
  const SlangQuizExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SlangQuizScreen(
      palavra: 'SMURF',
      classe: 'Substantivo',
      significado:
          'Jogador experiente que usa conta de nível baixo para dominar partidas mais fáceis.',
      exemplo: '"Cuidado com esse player, ele é um smurf clássico!"',
      usageHighlight: 'Esse cara é um SMURF — ele destruiu todo mundo!',
      cntCorreto: 0,
      cntErrado: 0,
      onClose: () {},
      onContinue: () {},
    );
  }
}