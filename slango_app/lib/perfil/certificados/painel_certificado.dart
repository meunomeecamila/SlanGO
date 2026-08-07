import 'package:flutter/material.dart';

import '../cores.dart';
import '../texto.dart';
import 'certificado_mundo_data.dart';
import 'certificado_pdf_service.dart';

/// Painel (bottom sheet) que abre quando o certificado está desbloqueado.
/// Mostra o ETzinho, a mensagem fofa e os DOIS botões de download.
class PainelCertificado extends StatelessWidget {
  final CertificadoMundo certificado;

  const PainelCertificado({super.key, required this.certificado});

  /// Abre o painel a partir de qualquer lugar.
  static Future<void> abrir(
    BuildContext context,
    CertificadoMundo certificado,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PainelCertificado(certificado: certificado),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            border: Border.all(
              color: certificado.corPrimaria.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ETzinho / mascote estático do mundo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: certificado.corPrimaria.withOpacity(0.55),
                        blurRadius: 45,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    certificado.petAsset,
                    height: 150,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.emoji_emotions_rounded,
                      size: 120,
                      color: certificado.corPrimaria,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                certificado.nome,
                textAlign: TextAlign.center,
                style: AppText.titulo(1),
              ),
              const SizedBox(height: 4),
              Text(
                'Certificado conquistado! 🎉',
                textAlign: TextAlign.center,
                style: AppText.subtitulo(0.95),
              ),

              const SizedBox(height: 18),

              // Mensagem fofa recheada com as gírias do planeta
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: certificado.corPrimaria.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  certificado.mensagem,
                  style: AppText.cardSubtitulo(1).copyWith(height: 1.5),
                ),
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: certificado.girias
                    .map(
                      (giria) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: certificado.corPrimaria.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: certificado.corPrimaria.withOpacity(0.6),
                          ),
                        ),
                        child: Text(
                          giria,
                          style: AppText.cardSubtitulo(0.85).copyWith(
                            color: certificado.corPrimaria,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // ==========================================================
              // BOTÃO 1 — PDF OFICIAL DO MUNDO (arquivo estático)
              // TODO: para REMOVER esta opção, apague o _BotaoDownload abaixo
              // (junto com o SizedBox seguinte) e, se quiser faxina completa,
              // o método `baixarPdfOficialDoMundo` em
              // certificado_pdf_service.dart.
              // ==========================================================
              _BotaoDownload(
                icone: Icons.workspace_premium_rounded,
                rotulo: 'Baixar certificado oficial (PDF)',
                cor: certificado.corPrimaria,
                aoTocar: () => _executar(
                  context,
                  () => CertificadoPdfService.baixarPdfOficialDoMundo(
                    certificado,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ==========================================================
              // BOTÃO 2 — PDF DA MENSAGEM DO ETZINHO (gerado na hora)
              // TODO: para REMOVER esta opção, apague o _BotaoDownload abaixo
              // e, se quiser, o método `baixarPdfDaMensagem` em
              // certificado_pdf_service.dart.
              // ==========================================================
              _BotaoDownload(
                icone: Icons.favorite_rounded,
                rotulo: 'Baixar recadinho do ETzinho (PDF)',
                cor: certificado.corSecundaria,
                contorno: true,
                aoTocar: () => _executar(
                  context,
                  () => CertificadoPdfService.baixarPdfDaMensagem(certificado),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _executar(
    BuildContext context,
    Future<void> Function() acao,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await acao();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível abrir o PDF. Confira se o arquivo existe em assets/pdfs/.',
          ),
        ),
      );
    }
  }
}

class _BotaoDownload extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final Color cor;
  final bool contorno;
  final VoidCallback aoTocar;

  const _BotaoDownload({
    required this.icone,
    required this.rotulo,
    required this.cor,
    required this.aoTocar,
    this.contorno = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: contorno
          ? OutlinedButton.icon(
              onPressed: aoTocar,
              icon: Icon(icone, color: cor),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: cor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              label: Text(
                rotulo,
                style: AppText.botao(0.9).copyWith(color: cor),
              ),
            )
          : ElevatedButton.icon(
              onPressed: aoTocar,
              icon: Icon(icone, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              label: Text(
                rotulo,
                style: AppText.botao(0.9).copyWith(color: Colors.white),
              ),
            ),
    );
  }
}