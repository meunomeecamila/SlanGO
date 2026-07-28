import 'package:flutter/material.dart';

import '../../mapa/styles/cores.dart';

class BackgroundEspaco extends StatelessWidget {
  final Widget child;

  const BackgroundEspaco({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bgTop,
            AppColors.bgBottom,
          ],
        ),
      ),
      child: Stack(
        children: [

          // Estrelas grandes
          const Positioned(
            top: 70,
            left: 40,
            child: Icon(
              Icons.star,
              color: Colors.white24,
              size: 10,
            ),
          ),

          const Positioned(
            top: 180,
            right: 55,
            child: Icon(
              Icons.star,
              color: Colors.white30,
              size: 8,
            ),
          ),

          const Positioned(
            bottom: 230,
            left: 80,
            child: Icon(
              Icons.star,
              color: Colors.white24,
              size: 10,
            ),
          ),

          const Positioned(
            bottom: 120,
            right: 45,
            child: Icon(
              Icons.star,
              color: Colors.white24,
              size: 12,
            ),
          ),

          child,
        ],
      ),
    );
  }
}