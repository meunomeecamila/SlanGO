import 'package:flutter/material.dart';

class Alien extends StatelessWidget {
  final String imagem;

  const Alien({
    super.key,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Image.asset(
        imagem,
        fit: BoxFit.contain,
      ),
    );
  }
}