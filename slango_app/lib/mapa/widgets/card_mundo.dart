import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../styles/cores.dart';
import '../styles/texto.dart';
import '../../l10n/l10n.dart';

/// Mapas de nome, descrição e status localizados para cada mundo (por id).
/// Mantém `mundo.nome`/`mundo.descricao`/`mundo.status` como fallback,
/// então mundos que ainda não tiverem tradução cadastrada aqui continuam
/// funcionando normalmente com o texto original.
String _nomeMundoLocalizado(BuildContext context, Mundo mundo) {
  final l10n = context.l10n;
  switch (mundo.id) {
    case 'jogos':
      return l10n.defaultWorldName;
    case 'kpop':
      return l10n.worldKpopName;
    case 'maquiagem':
      return l10n.worldMakeupName;
    case 'pop':
      return l10n.worldPopName;
    case 'antigo':
      return l10n.worldOldName;
    case 'cotidiano':
      return l10n.worldDailyName;
    case 'esportes':
      return l10n.worldSportsName;
    case 'geek':
      return l10n.worldGeekName;
    case 'redessociais':
      return l10n.worldSocialName;
    case 'relacionamentos':
      return l10n.worldRelationshipsName;
    case 'comunidade':
      return l10n.worldCommunityName;
    default:
      return mundo.nome;
  }
}

String _descricaoMundoLocalizada(BuildContext context, Mundo mundo) {
  final l10n = context.l10n;
  switch (mundo.id) {
    case 'jogos':
      return l10n.worldGamesDescription;
    case 'kpop':
      return l10n.worldKpopDescription;
    case 'maquiagem':
      return l10n.worldMakeupDescription;
    case 'pop':
      return l10n.worldPopDescription;
    case 'antigo':
      return l10n.worldOldDescription;
    case 'cotidiano':
      return l10n.worldDailyDescription;
    case 'esportes':
      return l10n.worldSportsDescription;
    case 'geek':
      return l10n.worldGeekDescription;
    case 'redessociais':
      return l10n.worldSocialDescription;
    case 'relacionamentos':
      return l10n.worldRelationshipsDescription;
    case 'comunidade':
      return l10n.worldCommunityDescription;
    default:
      return mundo.descricao;
  }
}

String _statusMundoLocalizado(BuildContext context, Mundo mundo) {
  if (mundo.status == 'Disponível') {
    return context.l10n.worldStatusAvailable;
  }
  return mundo.status;
}

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
                            _nomeMundoLocalizado(context, mundo),
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
                            _statusMundoLocalizado(context, mundo),
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
                          ? context.l10n.slangsLearnedProgress(
                              mundo.giriasAprendidas,
                              mundo.totalGirias,
                            )
                          : context.l10n.slangsToLearn(mundo.totalGirias),
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
            Text(
              _descricaoMundoLocalizada(context, mundo),
              style: AppText.cardSubtitulo(0.9),
            ),
          ],

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.learnedOfTotal(
                  mundo.giriasAprendidas,
                  mundo.totalGirias,
                ),
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
                mundo.desbloqueado
                    ? context.l10n.explorePlanet
                    : context.l10n.locked,
                style: AppText.botao(0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}