import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextStyle titulo(double scale) {
    return GoogleFonts.alfaSlabOne(
      color: Colors.white,
      fontSize: 30 * scale,
    );
  }

  static TextStyle subtitulo(double scale) {
    return GoogleFonts.poppins(
      color: Colors.white70,
      fontSize: 16 * scale,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle botao(double scale) {
    return GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 18 * scale,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle cardTitulo(double scale) {
    return GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 18 * scale,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle cardSubtitulo(double scale) {
    return GoogleFonts.poppins(
      color: Colors.white70,
      fontSize: 14 * scale,
    );
  }
}