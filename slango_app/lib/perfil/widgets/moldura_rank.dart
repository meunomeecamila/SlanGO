import 'package:flutter/material.dart';

/// Molduras de rank (Top 3 do ranking global), estilo League of Legends.
///
/// As imagens ficam em `images/bordar_de_perfil/` (registrado no pubspec.yaml).
class MolduraRank {
  static const String _base = 'images/bordar_de_perfil';

  /// Retorna o caminho da moldura para a posição no ranking global.
  /// 1º -> ouro, 2º -> prata, 3º -> bronze. Fora do Top 3 (ou null) -> null.
  static String? caminhoParaPosicao(int? posicao) {
    switch (posicao) {
      case 1:
        return '$_base/borda_primeiro_lugar.png';
      case 2:
        return '$_base/borda_segundo_lugar.png';
      case 3:
        return '$_base/borda_terceiro_lugar.png';
      default:
        return null; // Demais posições / sem ranking: sem moldura especial.
    }
  }
}

/// Sobrepõe a moldura de rank em volta de um avatar, estilo LoL.
///
/// O avatar fica centralizado e a moldura fica POR CIMA (levemente escalonada
/// para fora), usando `BoxFit.contain` para NÃO cobrir o rosto/foto.
class AvatarComMoldura extends StatelessWidget {
  /// Avatar já montado (CircleAvatar, ClipOval, Container circular, etc).
  final Widget avatar;

  /// Caminho da moldura (use [MolduraRank.caminhoParaPosicao]).
  /// Se `null`, apenas o avatar é exibido, sem moldura.
  final String? molduraPath;

  /// Tamanho base do avatar (usado como referência para a moldura).
  /// <-- AJUSTE AQUI O TAMANHO DA FOTO/ÁREA DO AVATAR
  final double tamanhoAvatar;

  // ─────────────── AJUSTES FINOS DA MOLDURA ───────────────
  /// <-- AJUSTE AQUI A ESCALA/TAMANHO DA BORDA (1.0 = mesmo tamanho do avatar,
  ///     >1.0 = moldura "estoura" para fora do avatar).
  final double escalaMoldura;

  /// <-- AJUSTE AQUI A POSIÇÃO HORIZONTAL da borda em pixels (negativo = esquerda).
  final double deslocamentoX;

  /// <-- AJUSTE AQUI A POSIÇÃO VERTICAL da borda em pixels (negativo = para cima).
  final double deslocamentoY;

  const AvatarComMoldura({
    super.key,
    required this.avatar,
    required this.molduraPath,
    this.tamanhoAvatar = 110,
    this.escalaMoldura = 1.32,
    this.deslocamentoX = 0,
    this.deslocamentoY = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Stack para sobrepor a moldura na foto de perfil.
    return Stack(
      clipBehavior: Clip.none, // permite a moldura ultrapassar os limites do avatar
      alignment: Alignment.center,
      children: [
        // 1. AVATAR (fica centralizado no Stack)
        avatar,

        // 2. MOLDURA DE RANK (1º, 2º ou 3º lugar)
        if (molduraPath != null)
          Positioned.fill(
            // IgnorePointer: a moldura é decorativa e não deve bloquear toques
            // no avatar (ex: abrir o seletor de avatar).
            child: IgnorePointer(
              child: Transform.translate(
                // <-- AJUSTE AQUI A POSIÇÃO SE PRECISAR DESLOCAR A BORDA
                offset: Offset(deslocamentoX, deslocamentoY),
                child: Transform.scale(
                  // <-- AJUSTE AQUI A ESCALA/TAMANHO DA BORDA
                  scale: escalaMoldura,
                  child: Image.asset(
                    molduraPath!,
                    // <-- AJUSTE AQUI A LARGURA/ALTURA DA MOLDURA
                    width: tamanhoAvatar,
                    height: tamanhoAvatar,
                    fit: BoxFit.contain, // mantém a moldura em volta, sem cobrir o rosto
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
    