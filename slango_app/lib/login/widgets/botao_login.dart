import 'package:flutter/material.dart';

import '../../mapa/styles/texto.dart';

class BotaoLogin extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool carregando;

  const BotaoLogin({
    super.key,
    required this.onPressed,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C5CFF),
          elevation: 10,
          shadowColor: const Color(0xFF7C5CFF).withOpacity(.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: carregando
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                "Entrar",
                style: AppText.botao(1.1),
              ),
      ),
    );
  }
}