import 'dart:math';

import 'package:flutter/material.dart';

/// Fundo de constelação interativa usado como plano de fundo padrão do app.
///
/// Partículas flutuam lentamente e se conectam por linhas quando estão
/// próximas (estilo particles.js). O ponteiro/toque repele as partículas.
///
/// Performance: a densidade foi reduzida pela metade (de 60 para 30
/// partículas) e o repaint acontece via `CustomPainter` + `AnimationController`
/// sem `setState`, para não travar dispositivos móveis.
class FundoEspacial extends StatefulWidget {
  /// Quantidade de partículas. Ajuste aqui se quiser mais/menos.
  final int quantidade;

  /// Distância máxima (px) para desenhar a linha entre duas partículas.
  final double distanciaConexao;

  /// Raio de repulsão do toque/mouse.
  final double raioRepulsao;

  /// Cor das partículas e das teias.
  final Color corParticulas;

  /// Quando `false`, o fundo ignora toques (apenas decorativo).
  final bool interativo;

  const FundoEspacial({
    super.key,
    this.quantidade = 30,
    this.distanciaConexao = 110,
    this.raioRepulsao = 90,
    this.corParticulas = const Color(0xFF9C8CF0),
    this.interativo = true,
  });

  @override
  State<FundoEspacial> createState() => _FundoEspacialState();
}

class _Particula {
  Offset posicao;
  Offset velocidade;
  _Particula(this.posicao, this.velocidade);
}

class _FundoEspacialState extends State<FundoEspacial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particula> _particulas = [];
  final _rand = Random(42);
  Offset? _ponteiro;
  Size _tamanho = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_atualizar);
    _controller.repeat();
  }

  void _inicializar(Size tamanho) {
    if (_particulas.isNotEmpty || tamanho.isEmpty) return;
    for (int i = 0; i < widget.quantidade; i++) {
      _particulas.add(
        _Particula(
          Offset(
            _rand.nextDouble() * tamanho.width,
            _rand.nextDouble() * tamanho.height,
          ),
          Offset(
            (_rand.nextDouble() - 0.5) * 0.6,
            (_rand.nextDouble() - 0.5) * 0.6,
          ),
        ),
      );
    }
  }

  void _atualizar() {
    if (_tamanho == Size.zero || _particulas.isEmpty) return;

    for (final p in _particulas) {
      Offset novaPos = p.posicao + p.velocidade;

      final ponteiro = _ponteiro;
      if (ponteiro != null) {
        final delta = novaPos - ponteiro;
        final dist = delta.distance;
        if (dist < widget.raioRepulsao && dist > 0) {
          final forca = (widget.raioRepulsao - dist) / widget.raioRepulsao;
          novaPos += (delta / dist) * forca * 6;
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
    _repaint.value++;
  }

  final ValueNotifier<int> _repaint = ValueNotifier<int>(0);

  @override
  void dispose() {
    _controller.dispose();
    _repaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final altura = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;

        _tamanho = Size(largura, altura);
        _inicializar(_tamanho);

        final pintura = SizedBox(
          width: largura,
          height: altura,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _ConstelacaoPainter(
                particulas: _particulas,
                distanciaConexao: widget.distanciaConexao,
                cor: widget.corParticulas,
                repaint: _repaint,
              ),
            ),
          ),
        );

        if (!widget.interativo) {
          return IgnorePointer(child: pintura);
        }

        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerHover: (e) => _ponteiro = e.localPosition,
          onPointerMove: (e) => _ponteiro = e.localPosition,
          onPointerDown: (e) => _ponteiro = e.localPosition,
          onPointerUp: (_) => _ponteiro = null,
          onPointerCancel: (_) => _ponteiro = null,
          child: pintura,
        );
      },
    );
  }
}

class _ConstelacaoPainter extends CustomPainter {
  final List<_Particula> particulas;
  final double distanciaConexao;
  final Color cor;

  _ConstelacaoPainter({
    required this.particulas,
    required this.distanciaConexao,
    required this.cor,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final pontoPaint = Paint()..color = cor.withOpacity(0.8);
    final linhaPaint = Paint()..strokeWidth = 0.6;

    for (int i = 0; i < particulas.length; i++) {
      canvas.drawCircle(particulas[i].posicao, 2, pontoPaint);

      for (int j = i + 1; j < particulas.length; j++) {
        final dist = (particulas[i].posicao - particulas[j].posicao).distance;
        if (dist < distanciaConexao) {
          linhaPaint.color =
              cor.withOpacity((1 - dist / distanciaConexao) * 0.5);
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
  bool shouldRepaint(covariant _ConstelacaoPainter oldDelegate) => false;
}
