import 'package:flutter/material.dart';

import '../cores.dart';
import '../texto.dart';
import 'certificado_mundo_data.dart';

/// Card de um mundo dentro da aba "Certificados".
///
/// - Bloqueado (progresso < 100%): cinza (preto e branco) + opacidade
///   reduzida + mensagem sobreposta. Não abre nada ao tocar.
/// - Desbloqueado (progresso = 100%): cores temáticas vibrantes e clicável.
class CardCertificadoMundo extends StatelessWidget {
  final CertificadoMundo certificado;
  final double progresso; // 0.0 .. 1.0
  final VoidCallback onAbrir;

  const CardCertificadoMundo({
    super.key,
    required this.certificado,
    required this.progresso,
    required this.onAbrir,
  });

  bool get desbloqueado => progresso >= 1.0;

  @override
  Widget build(BuildContext context) {
    final conteudo = _conteudo(context);

    if (desbloqueado) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAbrir,
            borderRadius: BorderRadius.circular(20),
            child: conteudo,
          ),
        ),
      );
    }

    // Bloqueado: preto e branco + opacidade + mensagem sobreposta.
    // (Sem InkWell: o card NÃO abre nada enquanto estiver bloqueado.)
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0, //
              0.2126, 0.7152, 0.0722, 0, 0, //
              0.2126, 0.7152, 0.0722, 0, 0, //
              0, 0, 0, 1, 0, //
            ]),
            child: Opacity(opacity: 0.45, child: conteudo),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Quando o mundo chegar a 100%, volte aqui!',
                      textAlign: TextAlign.center,
                      style: AppText.cardSubtitulo(0.95).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            certificado.corPrimaria.withOpacity(0.30),
            certificado.corSecundaria.withOpacity(0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: certificado.corPrimaria.withOpacity(0.75),
          width: 1.5,
        ),
        boxShadow: desbloqueado
            ? [
                BoxShadow(
                  color: certificado.corPrimaria.withOpacity(0.35),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(color: certificado.corPrimaria, width: 2),
            ),
            child: Image.asset(
              certificado.petAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.emoji_events_rounded,
                color: certificado.corPrimaria,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certificado.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardTitulo(0.95),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progresso.clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation(
                      certificado.corPrimaria,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desbloqueado
                      ? 'Certificado liberado — toque para abrir'
                      : '${(progresso * 100).round()}% explorado',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardSubtitulo(0.85),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            desbloqueado ? Icons.workspace_premium_rounded : Icons.lock_rounded,
            color:
                desbloqueado ? certificado.corSecundaria : AppColors.disabled,
          ),
        ],
      ),
    );
  }
}