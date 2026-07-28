import 'package:flutter/material.dart';
import '../styles/cores.dart';

class ListaGirias extends StatelessWidget {
  final List<String> girias;

  const ListaGirias({
    super.key,
    required this.girias,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: girias.map((giria) {
        return Chip(
          label: Text(
            giria,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}