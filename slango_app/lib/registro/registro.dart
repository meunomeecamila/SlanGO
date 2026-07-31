import 'package:flutter/material.dart';

import '../inicio/widgets/logo_slango.dart';
import '../mapa/mapa.dart';
import '../shared/widgets/background_espaco.dart';
import 'widgets/botao_registrar.dart';
import 'widgets/campo_texto.dart';
import 'widgets/seletor_tipo_usuario.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final idadeController = TextEditingController();

  bool ehPai = true;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  void registrar() {
    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem."),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MapaScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundEspaco(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LogoSlango(),

                    const SizedBox(height: 35),

                    CampoTexto(
                      label: "Nome",
                      icon: Icons.person,
                      controller: nomeController,
                    ),

                    const SizedBox(height: 18),

                    CampoTexto(
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),

                    const SizedBox(height: 18),

                    CampoTexto(
                      label: "Senha",
                      icon: Icons.lock,
                      obscureText: true,
                      controller: senhaController,
                    ),

                    const SizedBox(height: 18),

                    CampoTexto(
                      label: "Confirmar senha",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      controller: confirmarSenhaController,
                    ),

                    const SizedBox(height: 18),

                    CampoTexto(
                      label: "Idade",
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      controller: idadeController,
                    ),

                    const SizedBox(height: 24),

                    SeletorTipoUsuario(
                      ehPai: ehPai,
                      onChanged: (valor) {
                        setState(() {
                          ehPai = valor;
                        });
                      },
                    ),

                    const SizedBox(height: 35),

                    BotaoRegistrar(
                      onPressed: registrar,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}