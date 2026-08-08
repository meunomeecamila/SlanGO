import 'package:flutter/material.dart';

import '../models.dart';
import '../texto.dart';
import 'card_certificado_mundo.dart';
import 'certificado_mundo_data.dart';
import 'efeito_confete.dart';
import 'painel_certificado.dart';

/// Conteúdo da aba "Certificados" do perfil.
/// Lista um card por mundo, usando o progresso real vindo do backend.
class AbaCertificados extends StatelessWidget {
  final List<ProgressoMundo> mundos;

  /// Nome do usuário logado, para personalizar a mensagem do certificado
  /// (ex: "Aêêê, Vitor!" em vez de "Aêêê, astronauta!"). Passe null/vazio
  /// para manter o tratamento genérico "astronauta" (ex: sessão de
  /// convidado, ou nome ainda carregando).
  final String? nomeUsuario;

  const AbaCertificados({
    super.key,
    required this.mundos,
    this.nomeUsuario,
  });

  @override
  Widget build(BuildContext context) {
    if (mundos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Nenhum mundo explorado ainda. Comece a viagem! 🚀',
            textAlign: TextAlign.center,
            style: AppText.subtitulo(1),
          ),
        ),
      );
    }

    return Column(
      children: mundos.map((mundo) {
        final certificado = certificadoDoMundo(
          mundo.id.isNotEmpty ? mundo.id : mundo.nome,
        ).comNomeUsuario(nomeUsuario);

        return CardCertificadoMundo(
          certificado: certificado,
          progresso: mundo.progresso,
          onAbrir: () {
            // Efeito empolgante ao liberar o certificado.
            EfeitoConfete.disparar(
              context,
              cores: [
                certificado.corPrimaria,
                certificado.corSecundaria,
                Colors.white,
              ],
            );
            PainelCertificado.abrir(context, certificado);
          },
        );
      }).toList(),
    );
  }
}