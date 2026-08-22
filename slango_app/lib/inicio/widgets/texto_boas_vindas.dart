import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../mapa/styles/texto.dart';

class TextoBoasVindas extends StatelessWidget {
  const TextoBoasVindas({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Text(
        context.l10n.welcomeMessage,
        textAlign: TextAlign.center,
        style: AppText.subtitulo(1.2),
      ),
    );
  }
}