import 'package:flutter/material.dart';
import '../styles/cores.dart';

class BotaoMissao extends StatelessWidget {
  final VoidCallback onPressed;
  final String texto;

  const BotaoMissao({
    super.key,
    required this.onPressed,
    this.texto = "Iniciar missão",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch),
            const SizedBox(width: 10),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}