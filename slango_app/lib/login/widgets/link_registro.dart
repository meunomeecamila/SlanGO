import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class LinkRegistro extends StatelessWidget {
  final VoidCallback onTap;

  const LinkRegistro({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.dontHaveAccountYet,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            context.l10n.register,
            style: const TextStyle(
              color: Color(0xFF57E6D8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}