import 'package:flutter/material.dart';

import '../cores.dart';
import '../texto.dart';
import '../../final/Particulas.dart';

// Ajuste os imports acima para o caminho real de cores.dart e texto.dart
// no seu projeto (ex: '../../estilos/cores.dart').

/// Modelo simples de um usuário no ranking.
class UsuarioRanking {
  final String nome;
  final int acertos;
  final String avatarAsset;

  const UsuarioRanking({
    required this.nome,
    required this.acertos,
    required this.avatarAsset,
  });
}

class RankingScreen extends StatelessWidget {
  /// Nome do usuário logado, usado pra destacar sua própria linha/card
  /// no ranking. Passe o nome vindo do seu serviço de usuário.
  final String? nomeUsuarioAtual;

  const RankingScreen({super.key, this.nomeUsuarioAtual});

  // Dados estáticos (mock). Troque por dados reais quando o backend
  // de ranking estiver pronto.
  static const List<UsuarioRanking> _usuarios = [
    UsuarioRanking(
      nome: 'Camila Souza',
      acertos: 128,
      avatarAsset: 'assets/images/astronauta_1.png',
    ),
    UsuarioRanking(
      nome: 'João Pedro',
      acertos: 115,
      avatarAsset: 'assets/images/astronauta_2.png',
    ),
    UsuarioRanking(
      nome: 'Beatriz Lima',
      acertos: 102,
      avatarAsset: 'assets/images/astronauta_3.png',
    ),
    UsuarioRanking(
      nome: 'Rafael Costa',
      acertos: 97,
      avatarAsset: 'assets/images/astronauta_4.png',
    ),
    UsuarioRanking(
      nome: 'Mariana Alves',
      acertos: 89,
      avatarAsset: 'assets/images/astronauta_5.png',
    ),
    UsuarioRanking(
      nome: 'Lucas Fernandes',
      acertos: 81,
      avatarAsset: 'assets/images/astronauta_6.png',
    ),
    UsuarioRanking(
      nome: 'Ana Julia',
      acertos: 76,
      avatarAsset: 'assets/images/astronauta_7.png',
    ),
    UsuarioRanking(
      nome: 'Pedro Henrique',
      acertos: 68,
      avatarAsset: 'assets/images/astronauta_8.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Escala responsiva baseada na largura da tela (mesmo padrão usado
    // no SlangQuizScreen: baseline de 375px).
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 375).clamp(0.85, 1.2);

    final ordenados = List<UsuarioRanking>.from(_usuarios)
      ..sort((a, b) => b.acertos.compareTo(a.acertos));

    final top3 = ordenados.take(3).toList();
    final resto = ordenados.length > 3 ? ordenados.sublist(3) : <UsuarioRanking>[];

    return Scaffold(
      body: ParticulasFundo(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, scale),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
                  children: [
                    if (top3.isNotEmpty) _buildPodio(top3, scale, nomeUsuarioAtual),
                    SizedBox(height: 20 * scale),
                    ...List.generate(resto.length, (index) {
                      final usuario = resto[index];
                      final posicao = index + 4; // pódio ocupa 1-3
                      return _buildLinhaRanking(usuario, posicao, scale, nomeUsuarioAtual);
                    }),
                    SizedBox(height: 24 * scale),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double scale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16 * scale, 16 * scale, 16 * scale, 8 * scale),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22 * scale),
          ),
          SizedBox(width: 4 * scale),
          Expanded(
            child: Text(
              'Ranking',
              style: AppText.titulo(scale),
            ),
          ),
          Icon(Icons.emoji_events, color: AppColors.cyan, size: 26 * scale),
        ],
      ),
    );
  }

  Widget _buildPodio(List<UsuarioRanking> top3, double scale, String? nomeUsuarioAtual) {
    // Ordem visual: 2º, 1º, 3º (formato de pódio)
    final segundo = top3.length > 1 ? top3[1] : null;
    final primeiro = top3[0];
    final terceiro = top3.length > 2 ? top3[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (segundo != null)
          _buildPodioItem(segundo, 2, scale, altura: 96, ehVoce: segundo.nome == nomeUsuarioAtual),
        SizedBox(width: 10 * scale),
        _buildPodioItem(primeiro, 1, scale, altura: 124, ehVoce: primeiro.nome == nomeUsuarioAtual),
        SizedBox(width: 10 * scale),
        if (terceiro != null)
          _buildPodioItem(terceiro, 3, scale, altura: 78, ehVoce: terceiro.nome == nomeUsuarioAtual),
      ],
    );
  }

  Widget _buildPodioItem(
    UsuarioRanking usuario,
    int posicao,
    double scale, {
    required double altura,
    bool ehVoce = false,
  }) {
    final corMedalha = switch (posicao) {
      1 => const Color(0xFFFFD54F),
      2 => const Color(0xFFC0C0C0),
      _ => const Color(0xFFCD7F32),
    };
    final corBorda = ehVoce ? AppColors.cyan : corMedalha;
    final tamanhoAvatar = posicao == 1 ? 64.0 : 52.0;

    return SizedBox(
      width: 96 * scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (posicao == 1)
            Icon(Icons.emoji_events, color: corMedalha, size: 26 * scale),
          if (ehVoce) ...[
            SizedBox(height: 2 * scale),
            Text(
              'VOCÊ',
              style: TextStyle(
                fontSize: 10 * scale,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppColors.cyan,
              ),
            ),
          ],
          SizedBox(height: 4 * scale),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: tamanhoAvatar * scale,
                height: tamanhoAvatar * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: corBorda, width: ehVoce ? 3.5 * scale : 3 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: corBorda.withOpacity(ehVoce ? 0.85 : 0.5),
                      blurRadius: ehVoce ? 22 : 12,
                      spreadRadius: ehVoce ? 3 : 1,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    usuario.avatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.card,
                      child: Icon(Icons.person, color: AppColors.textSecondary, size: 28 * scale),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -6 * scale,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 2 * scale),
                  decoration: BoxDecoration(
                    color: corMedalha,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$posicao°',
                    style: TextStyle(
                      fontSize: 11 * scale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * scale),
          Text(
            usuario.nome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppText.cardTitulo(scale).copyWith(
              fontSize: 13 * scale,
              color: ehVoce ? AppColors.cyan : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2 * scale),
          Text(
            '${usuario.acertos} acertos',
            style: AppText.cardSubtitulo(scale).copyWith(fontSize: 11 * scale),
          ),
          SizedBox(height: 6 * scale),
          Container(
            height: altura * scale,
            width: 72 * scale,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(ehVoce ? 0.45 : 0.3),
                  AppColors.card,
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(
                color: ehVoce ? AppColors.cyan : const Color(0xFF9D7FFF).withOpacity(0.7),
                width: ehVoce ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (ehVoce ? AppColors.cyan : const Color(0xFF9D7FFF)).withOpacity(0.35),
                  blurRadius: 8,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinhaRanking(UsuarioRanking usuario, int posicao, double scale, String? nomeUsuarioAtual) {
    final ehVoce = usuario.nome == nomeUsuarioAtual;

    return Container(
      margin: EdgeInsets.only(bottom: 10 * scale),
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        color: ehVoce ? AppColors.primary.withOpacity(0.22) : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ehVoce ? AppColors.cyan : const Color(0xFF9D7FFF).withOpacity(0.55),
          width: ehVoce ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (ehVoce ? AppColors.cyan : const Color(0xFF9D7FFF)).withOpacity(ehVoce ? 0.35 : 0.18),
            blurRadius: ehVoce ? 16 : 6,
            spreadRadius: ehVoce ? 1 : 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28 * scale,
            child: Text(
              '$posicao°',
              style: AppText.cardSubtitulo(scale).copyWith(
                fontWeight: FontWeight.bold,
                color: ehVoce ? AppColors.cyan : AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 8 * scale),
          ClipOval(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ehVoce ? AppColors.cyan : const Color(0xFF9D7FFF).withOpacity(0.6),
                  width: ehVoce ? 2 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (ehVoce ? AppColors.cyan : const Color(0xFF9D7FFF)).withOpacity(ehVoce ? 0.5 : 0.25),
                    blurRadius: ehVoce ? 10 : 5,
                  ),
                ],
              ),
              child: Image.asset(
                usuario.avatarAsset,
                width: 40 * scale,
                height: 40 * scale,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 40 * scale,
                  height: 40 * scale,
                  color: AppColors.background,
                  child: Icon(Icons.person, color: AppColors.textSecondary, size: 20 * scale),
                ),
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    usuario.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitulo(scale).copyWith(
                      color: ehVoce ? AppColors.cyan : AppColors.textPrimary,
                      fontWeight: ehVoce ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
                ),
                if (ehVoce) ...[
                  SizedBox(width: 6 * scale),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 2 * scale),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'VOCÊ',
                      style: TextStyle(
                        fontSize: 9 * scale,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.cyan,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.cyan, size: 16 * scale),
              SizedBox(width: 4 * scale),
              Text(
                '${usuario.acertos}',
                style: AppText.numero(scale).copyWith(fontSize: 16 * scale),
              ),
            ],
          ),
        ],
      ),
    );
  }
}