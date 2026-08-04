import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shared/widgets/fundo_espacial.dart';

class RevisaoFinalScreen extends StatelessWidget {
  final String nomeMundo;
  final String mensagemBot;
  final String avatar; // caminho da imagem do personagem

  // Pergunta de múltipla escolha
  final String pergunta;
  final List<String> opcoes;
  final String? opcaoSelecionada;
  final ValueChanged<String> onSelecionarOpcao;

  final String fraseIncompleta;
  final List<String> palavrasOpcoes;
  final String? palavraSelecionada;
  final ValueChanged<String> onSelecionarPalavra;

  final VoidCallback onConcluir;

  const RevisaoFinalScreen({
    super.key,
    required this.pergunta,
    required this.opcoes,
    required this.onSelecionarOpcao,
    required this.fraseIncompleta,
    required this.palavrasOpcoes,
    required this.onSelecionarPalavra,
    required this.onConcluir,
    this.nomeMundo = 'Mundo Jogos',
    this.mensagemBot = 'Quase lá! Vamos revisar o que você aprendeu?',
    this.avatar = 'images/avatar.png',
    this.opcaoSelecionada,
    this.palavraSelecionada,
  });

  static const Color bgTop = Color(0xFF130A24);
  static const Color bgBottom = Color(0xFF1F1035);
  static const Color cardColor = Color(0xFF2A1B47);
  static const Color cardColorDark = Color(0xFF241640);
  static const Color purpleAccent = Color(0xFF7C5CFF);
  static const Color purpleLight = Color(0xFFB9A6FF);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.9, 1.25);
    final double heightScale = (size.height / 844).clamp(0.85, 1.35);

    return Scaffold(
      backgroundColor: bgBottom,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgTop, bgBottom],
              ),
            ),
          ),
          const Positioned.fill(child: FundoEspacial(interativo: false)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16 * heightScale),
                  _buildBadge(scale),
                  SizedBox(height: 18 * heightScale),
                  Text(
                    'Teste seus conhecimentos!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26 * scale,
                    ),
                  ),
                  SizedBox(height: 20 * heightScale),
                  _buildMensagemBot(scale),
                  SizedBox(height: 20 * heightScale),
                  _buildCardPergunta(scale),
                  SizedBox(height: 18 * heightScale),
                  _buildCardCompletarFrase(scale),
                  SizedBox(height: 24 * heightScale),
                  _buildBotaoConcluir(scale),
                  SizedBox(height: 24 * heightScale),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(double scale) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16 * scale,
          vertical: 8 * scale,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: purpleAccent.withOpacity(0.7)),
        ),
        child: Text(
          '$nomeMundo',
          style: TextStyle(
            color: purpleLight,
            fontWeight: FontWeight.bold,
            fontSize: 12 * scale,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMensagemBot(double scale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52 * scale,
          height: 52 * scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: purpleAccent.withOpacity(0.6)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            avatar,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.smart_toy, color: Colors.white54),
          ),
        ),
        SizedBox(width: 12 * scale),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16 * scale),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              mensagemBot,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.5 * scale,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardPergunta(double scale) {
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
            pergunta,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.5 * scale,
              height: 1.35,
            ),
          ),
          SizedBox(height: 14 * scale),
          for (final opcao in opcoes) ...[
            _buildOpcaoRow(opcao, scale),
            if (opcao != opcoes.last) SizedBox(height: 10 * scale),
          ],
        ],
      ),
    );
  }

  Widget _buildOpcaoRow(String opcao, double scale) {
    final bool selecionada = opcao == opcaoSelecionada;
    return GestureDetector(
      onTap: () => onSelecionarOpcao(opcao),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16 * scale,
          vertical: 14 * scale,
        ),
        decoration: BoxDecoration(
          color: selecionada ? purpleAccent.withOpacity(0.25) : cardColorDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selecionada ? purpleAccent : Colors.white.withOpacity(0.08),
            width: selecionada ? 1.5 : 1,
          ),
        ),
        child: Text(
          opcao,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.5 * scale,
            fontWeight: selecionada ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCardCompletarFrase(double scale) {
    final partes = fraseIncompleta.split('{}');
    final antes = partes.isNotEmpty ? partes[0] : '';
    final depois = partes.length > 1 ? partes[1] : '';

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
            'Complete a frase:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.5 * scale,
            ),
          ),
          SizedBox(height: 12 * scale),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 15 * scale,
                height: 1.4,
              ),
              children: [
                TextSpan(text: antes),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4 * scale),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * scale,
                      vertical: 2 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: purpleAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      palavraSelecionada ?? '____',
                      style: TextStyle(
                        color: purpleLight,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 15 * scale,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: depois),
              ],
            ),
          ),
          SizedBox(height: 16 * scale),
          Wrap(
            spacing: 10 * scale,
            runSpacing: 10 * scale,
            children: [
              for (final palavra in palavrasOpcoes)
                _buildChipPalavra(palavra, scale),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChipPalavra(String palavra, double scale) {
    final bool selecionada = palavra == palavraSelecionada;
    return GestureDetector(
      onTap: () => onSelecionarPalavra(palavra),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18 * scale,
          vertical: 10 * scale,
        ),
        decoration: BoxDecoration(
          color: selecionada ? purpleAccent : cardColorDark,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selecionada ? purpleAccent : purpleAccent.withOpacity(0.5),
          ),
        ),
        child: Text(
          palavra,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13.5 * scale,
          ),
        ),
      ),
    );
  }

  Widget _buildBotaoConcluir(double scale) {
    return SizedBox(
      width: double.infinity,
      height: 58 * scale,
      child: ElevatedButton(
        onPressed: onConcluir,
        style: ElevatedButton.styleFrom(
          backgroundColor: purpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          'Concluir Mundo 🏆',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16 * scale,
          ),
        ),
      ),
    );
  }
}

/// Exemplo de uso da tela
class RevisaoFinalExample extends StatefulWidget {
  const RevisaoFinalExample({super.key});

  @override
  State<RevisaoFinalExample> createState() => _RevisaoFinalExampleState();
}

class _RevisaoFinalExampleState extends State<RevisaoFinalExample> {
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
      onConcluir: () {},
    );
  }
}
