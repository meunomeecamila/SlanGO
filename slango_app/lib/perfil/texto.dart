import 'package:flutter/material.dart';

import 'cores.dart';

/// Estilos de texto do SlanGo.
/// Se o seu projeto já tiver um AppText em outro lugar,
/// pode apagar este arquivo e trocar os imports pelo seu.
class AppText {
  static TextStyle titulo(double scale) => TextStyle(
        fontSize: 22 * scale,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle subtitulo(double scale) => TextStyle(
        fontSize: 14 * scale,
        color: AppColors.textSecondary,
      );

  static TextStyle cardTitulo(double scale) => TextStyle(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle cardSubtitulo(double scale) => TextStyle(
        fontSize: 13 * scale,
        color: AppColors.textSecondary,
      );

  static TextStyle botao(double scale) => TextStyle(
        fontSize: 15 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle numero(double scale) => TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.bold,
        color: AppColors.cyan,
      );
}