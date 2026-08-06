import 'package:flutter/material.dart';

import '../../login/login.dart';
import '../../mapa/mapa.dart';
import '../../mapa/styles/texto.dart';
import '../../registro/registro.dart';
import '../../service/usuarioService.dart';

class BotoesInicio extends StatefulWidget {
  const BotoesInicio({super.key});

  @override
  State<BotoesInicio> createState() => _BotoesInicioState();
}

class _BotoesInicioState extends State<BotoesInicio> {
  bool carregando = false;

  Future<void> entrarComoConvidado() async {
    if (carregando) return;

    setState(() => carregando = true);

    try {
      await UsuarioService.entrarComoConvidado();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapaScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 320,
          height: 50,
          child: ElevatedButton(
            onPressed: carregando
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
            child: Text("Fazer Login", style: AppText.botao(1.1)),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: 320,
          height: 50,
          child: OutlinedButton(
            onPressed: carregando
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegistroScreen()),
                    );
                  },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF57E6D8), width: 2.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Text(
              "Registrar",
              style: AppText.botao(
                1.1,
              ).copyWith(color: const Color(0xFF57E6D8)),
            ),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: 320,
          height: 50,
          child: OutlinedButton(
            onPressed: carregando ? null : entrarComoConvidado,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white70, width: 2.5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Text(
              carregando ? 'Entrando...' : 'Entrar sem Login',
              style: AppText.botao(1.1).copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
