import 'dart:math';

import 'package:flutter/material.dart';



class ParticulasFundo extends StatefulWidget {
  final Widget child;
  final int quantidade;
  final double distanciaConexao;
  final double raioRepulsao;
  final Color corParticulas;
  final bool interativo;

  const ParticulasFundo({
    super.key,
    required this.child,
    this.quantidade = 35,
    this.distanciaConexao = 120,
    this.raioRepulsao = 90,
    this.corParticulas = const Color(0xFFB19CFF),
    this.interativo = true,
  });

  @override
  State<ParticulasFundo> createState() => _ParticulasFundoState();
}

class _Particula {
  Offset posicao;
  Offset velocidade;
  _Particula(this.posicao, this.velocidade);
}

class _ParticulasFundoState extends State<ParticulasFundo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particula> _particulas = [];
  Offset? _ponteiro;
  Size _tamanho = Size.zero;
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_atualizar);
    _controller.repeat();
  }

  void _inicializarParticulas(Size tamanho) {
    if (_particulas.isNotEmpty) return;
    for (int i = 0; i < widget.quantidade; i++) {
      final pos = Offset(
        _rand.nextDouble() * tamanho.width,
        _rand.nextDouble() * tamanho.height,
      );
      final vel = Offset(
        (_rand.nextDouble() - 0.5) * 0.25,
        (_rand.nextDouble() - 0.5) * 0.25,
      );
      _particulas.add(_Particula(pos, vel));
    }
  }

  void _atualizar() {
    if (_tamanho == Size.zero || _particulas.isEmpty) return;

    for (final p in _particulas) {
      Offset novaPos = p.posicao + p.velocidade;

      
      if (widget.interativo) {
        final ponteiro = _ponteiro;
        if (ponteiro != null) {
          final delta = novaPos - ponteiro;
          final dist = delta.distance;
          if (dist < widget.raioRepulsao && dist > 0) {
            final forca = (widget.raioRepulsao - dist) / widget.raioRepulsao;
            final direcao = delta / dist;
            novaPos += direcao * forca * 6;
          }
        }
      }

      
      double dx = p.velocidade.dx;
      double dy = p.velocidade.dy;
      if (novaPos.dx <= 0 || novaPos.dx >= _tamanho.width) dx = -dx;
      if (novaPos.dy <= 0 || novaPos.dy >= _tamanho.height) dy = -dy;

      p.velocidade = Offset(dx, dy);
      p.posicao = Offset(
        novaPos.dx.clamp(0, _tamanho.width),
        novaPos.dy.clamp(0, _tamanho.height),
      );
    }
    setState(() {});
  }

  void _atualizarPonteiro(Offset pos) => _ponteiro = pos;
  void _removerPonteiro() => _ponteiro = null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _tamanho = Size(constraints.maxWidth, constraints.maxHeight);
        _inicializarParticulas(_tamanho);

        final camadas = Stack(
          children: [
            
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF130A24), Color(0xFF1F1035)],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 70,
              left: 40,
              child: Icon(Icons.star, color: Colors.white24, size: 10),
            ),
            const Positioned(
              top: 180,
              right: 55,
              child: Icon(Icons.star, color: Colors.white30, size: 8),
            ),
            const Positioned(
              bottom: 230,
              left: 80,
              child: Icon(Icons.star, color: Colors.white24, size: 10),
            ),
            const Positioned(
              bottom: 120,
              right: 45,
              child: Icon(Icons.star, color: Colors.white24, size: 12),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ParticulasPainter(
                    particulas: _particulas,
                    distanciaConexao: widget.distanciaConexao,
                    cor: widget.corParticulas,
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        );

        if (!widget.interativo) return camadas;

        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerHover: (e) => _atualizarPonteiro(e.localPosition),
          onPointerMove: (e) => _atualizarPonteiro(e.localPosition),
          onPointerDown: (e) => _atualizarPonteiro(e.localPosition),
          onPointerUp: (_) => _removerPonteiro(),
          onPointerCancel: (_) => _removerPonteiro(),
          child: camadas,
        );
      },
    );
  }
}

class _ParticulasPainter extends CustomPainter {
  final List<_Particula> particulas;
  final double distanciaConexao;
  final Color cor;

  _ParticulasPainter({
    required this.particulas,
    required this.distanciaConexao,
    required this.cor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pontoPaint = Paint()..color = cor.withValues(alpha: 1.0);

    for (int i = 0; i < particulas.length; i++) {
      canvas.drawCircle(particulas[i].posicao, 2.6, pontoPaint);

      for (int j = i + 1; j < particulas.length; j++) {
        final dist = (particulas[i].posicao - particulas[j].posicao).distance;
        if (dist < distanciaConexao) {
          final opacidade = (1 - dist / distanciaConexao) * 0.65;
          final linhaPaint = Paint()
            ..color = cor.withValues(alpha: opacidade)
            ..strokeWidth = 0.6;
          canvas.drawLine(
            particulas[i].posicao,
            particulas[j].posicao,
            linhaPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticulasPainter oldDelegate) => true;
}