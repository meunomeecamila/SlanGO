import 'package:flutter/material.dart';

import '../../mapa/styles/texto.dart';

class TextoBoasVindas extends StatelessWidget {
  const TextoBoasVindas({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Text(
        "Aprenda gírias de diversas comunidades para se aproximar de quem você ama!",
        textAlign: TextAlign.center,
        style: AppText.subtitulo(1.2),
      ),
    );
  }
}