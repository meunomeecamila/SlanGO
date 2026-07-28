import 'package:flutter/material.dart';

import '../styles/cores.dart';

class NavegacaoMundos extends StatelessWidget {
  final int paginaAtual;
  final int totalPaginas;
  final VoidCallback? onAnterior;
  final VoidCallback? onProximo;

  const NavegacaoMundos({
    super.key,
    required this.paginaAtual,
    required this.totalPaginas,
    this.onAnterior,
    this.onProximo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.card,
          child: IconButton(
            onPressed: onAnterior,
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
          ),
        ),

        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              totalPaginas,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: index == paginaAtual
                      ? AppColors.primary
                      : AppColors.disabled,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),

        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.card,
          child: IconButton(
            onPressed: onProximo,
            icon: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}