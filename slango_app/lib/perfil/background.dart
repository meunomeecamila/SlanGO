import 'package:flutter/material.dart';

import 'cores.dart';

/// Fundo espacial (gradiente roxo escuro) usado em todas as telas.
/// Se o seu projeto já tiver um BackgroundEspaco em outro lugar,
/// pode apagar este arquivo e trocar os imports pelo seu.
class BackgroundEspaco extends StatelessWidget {
  final Widget child;

  const BackgroundEspaco({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.backgroundEnd],
        ),
      ),
      child: child,
    );
  }
}