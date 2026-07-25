import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../styles/cores.dart';
import '../styles/texto.dart';

class CardMundo extends StatelessWidget {
  final Mundo mundo;
  final VoidCallback? onExplorar;

  const CardMundo({
    super.key,
    required this.mundo,
    this.onExplorar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  mundo.imagem,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mundo.nome,
                      style: AppText.cardTitulo(1),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${mundo.totalGirias} gírias para aprender",
                      style: AppText.cardSubtitulo(1),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: mundo.progresso,
              minHeight: 10,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: mundo.desbloqueado ? onExplorar : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                mundo.desbloqueado
                    ? "Explorar Planeta"
                    : "Bloqueado",
                style: AppText.botao(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}