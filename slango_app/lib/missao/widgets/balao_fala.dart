import 'package:flutter/material.dart';

class BalaoFala extends StatelessWidget {
  final String texto;

  const BalaoFala({
    super.key,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BalaoPainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        margin: const EdgeInsets.only(bottom: 20),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class BalaoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height - 15,
        ),
        const Radius.circular(25),
      ),
    );

    // pontinha do balão
    path.moveTo(size.width / 2 - 15, size.height - 15);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 15, size.height - 15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}