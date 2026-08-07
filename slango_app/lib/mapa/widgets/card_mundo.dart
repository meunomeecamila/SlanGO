import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../styles/cores.dart';
import '../styles/texto.dart';

class CardMundo extends StatelessWidget {
  final Mundo mundo;
  final VoidCallback? onExplorar;

  const CardMundo({super.key, required this.mundo, this.onExplorar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  mundo.imagem,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            mundo.nome,
                            style: AppText.cardTitulo(0.95),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (mundo.desbloqueado
                                        ? AppColors.cyan
                                        : AppColors.disabled)
                                    .withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            mundo.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.cardSubtitulo(0.8).copyWith(
                              color: mundo.desbloqueado
                                  ? AppColors.cyan
                                  : AppColors.disabled,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      mundo.giriasAprendidas > 0
                          ? "${mundo.giriasAprendidas}/${mundo.totalGirias} gírias aprendidas"
                          : "${mundo.totalGirias} gírias para aprender",
                      style: AppText.cardSubtitulo(0.9),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (mundo.descricao.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(mundo.descricao, style: AppText.cardSubtitulo(0.9)),
          ],

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mundo.giriasAprendidas > 0
                    ? "${mundo.giriasAprendidas}/${mundo.totalGirias} aprendidas"
                    : "0/${mundo.totalGirias} aprendidas",
                style: AppText.cardSubtitulo(0.85),
              ),
              Text(
                "${(mundo.progresso * 100).round()}%",
                style: AppText.cardSubtitulo(0.85),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: mundo.progresso,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: mundo.desbloqueado ? onExplorar : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                mundo.desbloqueado ? "Explorar Planeta" : "Bloqueado",
                style: AppText.botao(0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
