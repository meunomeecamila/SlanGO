import 'package:flutter/material.dart';

import '../../login/login.dart';
import '../../registro/registro.dart';
import '../../mapa/styles/texto.dart';

class BotoesInicio extends StatelessWidget {
  const BotoesInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 320,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C5CFF),
              foregroundColor: Colors.white,
              elevation: 10,
              shadowColor: const Color(0xFF7C5CFF).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Text(
              "Fazer Login",
              style: AppText.botao(1.1),
            ),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: 320,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegistroScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFF57E6D8),
                width: 2.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Text(
              "Registrar",
              style: AppText.botao(1.1).copyWith(
                color: const Color(0xFF57E6D8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}