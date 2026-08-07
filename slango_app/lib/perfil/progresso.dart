import 'package:flutter/material.dart';

import 'cores.dart';
import 'texto.dart';
import '../final/Particulas.dart';
import 'models.dart';

class ProgressoScreen extends StatelessWidget {
  final List<ProgressoMundo> mundos;

  const ProgressoScreen({super.key, required this.mundos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticulasFundo(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Expanded(
                  child: mundos.isEmpty
                      ? Center(
                          child: Text(
                            "Nenhum mundo disponível ainda.",
                            style: AppText.subtitulo(1),
                          ),
                        )
                      : ListView.separated(
                          itemCount: mundos.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, index) => _cardMundo(mundos[index]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Progresso", style: AppText.titulo(0.85)),
              const SizedBox(height: 2),
              Text(
                "Acompanhe aqui o progresso dos mundos",
                style: AppText.subtitulo(0.9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardMundo(ProgressoMundo mundo) {
    final porcentagem = (mundo.progresso * 100).round();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        // TODO: navegar para a tela do mundo quando o backend estiver pronto
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Selo circular com a porcentagem no lugar do ícone de globo
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: mundo.progresso,
                        strokeWidth: 3.5,
                        backgroundColor: AppColors.disabled,
                        valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                      ),
                      Text(
                        "$porcentagem%",
                        style: AppText.cardSubtitulo(0.68).copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(mundo.nome, style: AppText.cardTitulo(1)),
                ),
                Text(
                  "${mundo.girasAprendidas}/${mundo.totalGirias}",
                  style: AppText.cardSubtitulo(0.9),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: mundo.progresso,
                minHeight: 8,
                backgroundColor: AppColors.disabled,
                valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}