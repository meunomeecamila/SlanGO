import 'package:flutter/material.dart';

class SeletorTipoUsuario extends StatelessWidget {
  final bool ehPai;
  final ValueChanged<bool> onChanged;

  const SeletorTipoUsuario({
    super.key,
    required this.ehPai,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Botao(
            texto: "Pai / Mãe",
            selecionado: ehPai,
            onTap: () => onChanged(true),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _Botao(
            texto: "Filho(a)",
            selecionado: !ehPai,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _Botao extends StatelessWidget {
  final String texto;
  final bool selecionado;
  final VoidCallback onTap;

  const _Botao({
    required this.texto,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58,
        decoration: BoxDecoration(
          color: selecionado
              ? const Color(0xFF57E6D8)
              : Colors.white.withOpacity(.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selecionado
                ? const Color(0xFF57E6D8)
                : Colors.white24,
          ),
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: selecionado
                  ? const Color(0xFF1F1035)
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}