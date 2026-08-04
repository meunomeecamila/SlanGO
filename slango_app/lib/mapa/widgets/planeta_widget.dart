import 'package:flutter/material.dart';

import '../models/mundo.dart';
import '../styles/cores.dart';
import '../styles/texto.dart';

class PlanetaWidget extends StatefulWidget {
  final Mundo mundo;

  const PlanetaWidget({super.key, required this.mundo});

  @override
  State<PlanetaWidget> createState() => _PlanetaWidgetState();
}

class _PlanetaWidgetState extends State<PlanetaWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotacao;

  @override
  void initState() {
    super.initState();
    // VELOCIDADE DA ROTACAO DO PLANETA: quanto maior a duracao, mais devagar.
    _rotacao = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _rotacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mundo = widget.mundo;
    final size = MediaQuery.of(context).size;
    final escalaPelaLargura = size.width / 390;
    final escalaPelaAltura = size.height / 844;
    final scale =
        (escalaPelaLargura < escalaPelaAltura
                ? escalaPelaLargura
                : escalaPelaAltura)
            .clamp(0.65, 1.0);

    return Column(
      children: [
        SizedBox(
          height: 35 * scale,
        ), // tamnho sombraa de cima  ACHEI ONDE ARRUMA
        Container(
          width: 185 * scale,
          height: 185 * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 44,
                spreadRadius: 4,
              ),
            ],
          ),
          // Rotacao continua e suave da imagem do planeta (gira no proprio eixo).
          child: RotationTransition(
            turns: _rotacao,
            child: Image.asset(mundo.imagem, fit: BoxFit.contain),
          ),
        ),

        SizedBox(height: 10 * scale),

        Text(
          mundo.nome,
          textAlign: TextAlign.center,
          style: AppText.titulo(scale * 0.9),
        ),

        SizedBox(height: 6 * scale),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                mundo.desbloqueado ? Icons.auto_awesome : Icons.lock,
                color: mundo.desbloqueado ? AppColors.cyan : AppColors.disabled,
                size: 18,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  mundo.status,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppText.subtitulo(scale * 0.92).copyWith(
                    color: mundo.desbloqueado
                        ? AppColors.textSecondary
                        : AppColors.disabled,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
