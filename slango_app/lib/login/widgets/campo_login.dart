import 'package:flutter/material.dart';

import '../../mapa/styles/texto.dart';

class CampoLogin extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CampoLogin({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF57E6D8),
        ),
        labelText: label,
        labelStyle: AppText.cardSubtitulo(1),
        filled: true,
        fillColor: Colors.white.withOpacity(.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF57E6D8),
            width: 2,
          ),
        ),
      ),
    );
  }
}