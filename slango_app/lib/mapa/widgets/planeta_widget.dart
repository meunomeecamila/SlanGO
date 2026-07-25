import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../styles/cores.dart';
import '../styles/texto.dart';

class PlanetaWidget extends StatelessWidget {
  final Mundo mundo;

  const PlanetaWidget({
    super.key,
    required this.mundo,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 390).clamp(0.9, 1.2);

    return Column(
      children: [
        Container(
          width: 260 * scale,
          height: 260 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 70,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Image.asset(
            mundo.imagem,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: 20 * scale),

        Text(
          mundo.nome,
          textAlign: TextAlign.center,
          style: AppText.titulo(scale),
        ),

        SizedBox(height: 8 * scale),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mundo.desbloqueado
                  ? Icons.auto_awesome
                  : Icons.lock,
              color: mundo.desbloqueado
                  ? AppColors.cyan
                  : AppColors.disabled,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              mundo.descricao,
              style: AppText.subtitulo(scale).copyWith(
                color: mundo.desbloqueado
                    ? AppColors.textSecondary
                    : AppColors.disabled,
              ),
            ),
          ],
        ),
      ],
    );
  }
}