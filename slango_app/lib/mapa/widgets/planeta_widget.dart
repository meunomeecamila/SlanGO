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
    final escalaPelaLargura = size.width / 390;
    final escalaPelaAltura = size.height / 844;
    final scale = (escalaPelaLargura < escalaPelaAltura
            ? escalaPelaLargura
            : escalaPelaAltura)
        .clamp(0.7, 1.1);

    return Column(
      children: [
        Container(
          width: 210 * scale,
          height: 210 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 50,
                spreadRadius: 6,
              ),
            ],
          ),
          child: Image.asset(
            mundo.imagem,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: 14 * scale),

        Text(
          mundo.nome,
          textAlign: TextAlign.center,
          style: AppText.titulo(scale),
        ),

        SizedBox(height: 8 * scale),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
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
              Flexible(
                child: Text(
                  mundo.descricao,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppText.subtitulo(scale).copyWith(
                    color: mundo.desbloqueado
                        ? AppColors.textSecondary
                        : AppColors.disabled,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}