import 'package:flutter/material.dart';

class LinkRegistro extends StatelessWidget {
  final VoidCallback onTap;

  const LinkRegistro({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Ainda não possui uma conta? ",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "Registrar",
            style: TextStyle(
              color: Color(0xFF57E6D8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}