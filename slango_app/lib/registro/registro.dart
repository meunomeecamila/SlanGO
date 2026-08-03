import 'package:flutter/material.dart';

import '../inicio/widgets/logo_slango.dart';
import '../login/login.dart';
import '../mapa/mapa.dart';
import '../mapa/styles/texto.dart';
import '../shared/widgets/background_espaco.dart';
import '../service/UserService.dart';
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
  bool carregando = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> registrar() async {
    if (nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      _mostrarErro("Preencha todos os campos obrigatórios.");
      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      _mostrarErro("As senhas não coincidem.");
      return;
    }

    setState(() => carregando = true);

    try {
      await UsuarioService.cadastrar(
        nome: nomeController.text.trim(),
        email: emailController.text.trim(),
        senha: senhaController.text,
        confirmarSenha: confirmarSenhaController.text,
        responsavel: ehPai,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MapaScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => carregando = false);
    }
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
                      "Criar Conta",
                      textAlign: TextAlign.center,
                      style: AppText.titulo(0.95),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Comece sua aventura no universo das gírias!",
                      textAlign: TextAlign.center,
                      style: AppText.subtitulo(0.95),
                    ),

                    const SizedBox(height: 45),

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
                      onPressed: carregando ? null : registrar,
                      carregando: carregando,
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Já possui uma conta? ",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Fazer Login",
                            style: TextStyle(
                              color: Color(0xFF57E6D8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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