import 'dart:math';

import 'package:flutter/material.dart';

/// Efeito visual de confetes/partículas disparado ao abrir um certificado.
///
/// Implementado sem dependências externas: um [OverlayEntry] com um
/// [CustomPainter] animado que se remove sozinho ao terminar.
class EfeitoConfete {
  const EfeitoConfete._();

  /// Dispara o efeito por cima de toda a tela.
  static void disparar(
    BuildContext context, {
    List<Color> cores = const [Color(0xFF7C5CFF), Color(0xFF32E0C4)],
    Duration duracao = const Duration(milliseconds: 2200),
    int quantidade = 90,
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entrada;
    entrada = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: _ConfeteAnimado(
          cores: cores,
          duracao: duracao,
          quantidade: quantidade,
          aoTerminar: () => entrada.remove(),
        ),
      ),
    );

    overlay.insert(entrada);
  }
}

class _ConfeteAnimado extends StatefulWidget {
  final List<Color> cores;
  final Duration duracao;
  final int quantidade;
  final VoidCallback aoTerminar;

  const _ConfeteAnimado({
    required this.cores,
    required this.duracao,
    required this.quantidade,
    required this.aoTerminar,
  });

  @override
  State<_ConfeteAnimado> createState() => _ConfeteAnimadoState();
}

class _ConfeteAnimadoState extends State<_ConfeteAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particula> _particulas;

  @override
  void initState() {
    super.initState();
    final random = Random();

    _particulas = List.generate(widget.quantidade, (index) {
      return _Particula(
        xInicial: random.nextDouble(),
        yInicial: random.nextDouble() * 0.35,
        velocidadeX: (random.nextDouble() - 0.5) * 0.35,
        velocidadeY: 0.55 + random.nextDouble() * 0.75,
        tamanho: 4 + random.nextDouble() * 7,
        rotacao: random.nextDouble() * pi,
        velocidadeRotacao: (random.nextDouble() - 0.5) * 10,
        cor: widget.cores[random.nextInt(widget.cores.length)],
      );
    });

    _controller = AnimationController(vsync: this, duration: widget.duracao)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.aoTerminar();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _ConfetePainter(
          particulas: _particulas,
          progresso: _controller.value,
        ),
      ),
    );
  }
}

class _Particula {
  final double xInicial;
  final double yInicial;
  final double velocidadeX;
  final double velocidadeY;
  final double tamanho;
  final double rotacao;
  final double velocidadeRotacao;
  final Color cor;

  const _Particula({
    required this.xInicial,
    required this.yInicial,
    required this.velocidadeX,
    required this.velocidadeY,
    required this.tamanho,
    required this.rotacao,
    required this.velocidadeRotacao,
    required this.cor,
  });
}

class _ConfetePainter extends CustomPainter {
  final List<_Particula> particulas;
  final double progresso;

  const _ConfetePainter({required this.particulas, required this.progresso});

  @override
  void paint(Canvas canvas, Size size) {
    final opacidade = (1 - progresso).clamp(0.0, 1.0);

    for (final p in particulas) {
      final x = (p.xInicial + p.velocidadeX * progresso) * size.width;
      final y = (p.yInicial + p.velocidadeY * progresso) * size.height;

      final paint = Paint()..color = p.cor.withOpacity(opacidade);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotacao + p.velocidadeRotacao * progresso);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.tamanho,
            height: p.tamanho * 1.6,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfetePainter oldDelegate) =>
      oldDelegate.progresso != progresso;
}
