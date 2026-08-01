import 'package:flutter/material.dart';

import '../inicio/widgets/logo_slango.dart';
import '../mapa/mapa.dart';
import '../mapa/styles/texto.dart';
import '../registro/registro.dart';
import '../shared/widgets/background_espaco.dart';

import 'widgets/botao_login.dart';
import 'widgets/campo_login.dart';
import 'widgets/link_registro.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void entrar() {
    // Futuramente aqui será feita a autenticação com o backend.

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
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 18,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const LogoSlango(),

                    const SizedBox(height: 18),

                    Text(
                      "Entrar",
                      textAlign: TextAlign.center,
                      style: AppText.titulo(0.95),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Continue sua missão pelo universo das gírias!",
                      textAlign: TextAlign.center,
                      style: AppText.subtitulo(0.95),
                    ),

                    const SizedBox(height: 50),

                    CampoLogin(
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),

                    const SizedBox(height: 18),

                    CampoLogin(
                      label: "Senha",
                      icon: Icons.lock,
                      obscureText: true,
                      controller: senhaController,
                    ),

                    const SizedBox(height: 35),

                    BotaoLogin(
                      onPressed: entrar,
                    ),

                    const SizedBox(height: 24),

                    LinkRegistro(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistroScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
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