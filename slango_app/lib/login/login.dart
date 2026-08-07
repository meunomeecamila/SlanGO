import 'package:flutter/material.dart';

import '../inicio/widgets/logo_slango.dart';
import '../mapa/mapa.dart';
import '../mapa/styles/texto.dart';
import '../registro/registro.dart';
import '../shared/widgets/background_espaco.dart';
import '../shared/widgets/fundo_espacial.dart';
import '../service/usuarioService.dart';

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

  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _abrirDialogoRecuperarSenha(BuildContext context) async {
    final emailController = TextEditingController();
    final respostaController = TextEditingController();
    final novaSenhaController = TextEditingController();
    final confirmarSenhaController = TextEditingController();

    String? perguntaSeguranca;
    bool carregandoPergunta = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF241A3D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Recuperar senha',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed:
                            carregandoPergunta ||
                                emailController.text.trim().isEmpty
                            ? null
                            : () async {
                                final email = emailController.text.trim();
                                setState(() => carregandoPergunta = true);

                                try {
                                  final pergunta =
                                      await UsuarioService.obterPerguntaSeguranca(
                                        email,
                                      );
                                  if (!mounted) return;
                                  setState(() => perguntaSeguranca = pergunta);
                                } catch (e) {
                                  if (!mounted) return;
                                  setState(() => perguntaSeguranca = null);
                                  this._mostrarErro(
                                    e.toString().replaceFirst(
                                      'Exception: ',
                                      '',
                                    ),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => carregandoPergunta = false);
                                  }
                                }
                              },
                        child: Text(
                          carregandoPergunta
                              ? 'Buscando...'
                              : 'Buscar pergunta',
                          style: const TextStyle(color: Color(0xFF57E6D8)),
                        ),
                      ),
                    ),
                    if (perguntaSeguranca != null &&
                        perguntaSeguranca!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          perguntaSeguranca!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: respostaController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Resposta de segurança',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: novaSenhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nova senha',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: confirmarSenhaController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Confirmar nova senha',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final resposta = respostaController.text.trim();
                    final novaSenha = novaSenhaController.text;
                    final confirmarSenha = confirmarSenhaController.text;

                    if (email.isEmpty ||
                        perguntaSeguranca == null ||
                        perguntaSeguranca!.isEmpty) {
                      this._mostrarErro(
                        'Busque a pergunta de segurança primeiro.',
                      );
                      return;
                    }

                    if (resposta.isEmpty ||
                        novaSenha.isEmpty ||
                        confirmarSenha.isEmpty) {
                      this._mostrarErro('Preencha todos os campos.');
                      return;
                    }

                    if (novaSenha != confirmarSenha) {
                      this._mostrarErro('As senhas não coincidem.');
                      return;
                    }

                    try {
                      await UsuarioService.recuperarSenha(
                        email: email,
                        novaSenha: novaSenha,
                        confirmarNovaSenha: confirmarSenha,
                        respostaSeguranca: resposta,
                      );

                      if (!mounted) return;
                      Navigator.of(dialogContext).pop();
                      this._mostrarErro('Senha atualizada com sucesso.');
                    } catch (e) {
                      if (!mounted) return;
                      this._mostrarErro(
                        e.toString().replaceFirst('Exception: ', ''),
                      );
                    }
                  },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(color: Color(0xFF57E6D8)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> entrar() async {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      _mostrarErro("Preencha email e senha.");
      return;
    }

    setState(() => carregando = true);

    try {
      await UsuarioService.login(
        emailController.text.trim(),
        senhaController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapaScreen()),
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
      body: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundEspaco(child: SizedBox.expand()),
          ),
          const Positioned.fill(child: FundoEspacial(interativo: false)),
          SafeArea(
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
                        onPressed: carregando ? null : entrar,
                        carregando: carregando,
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => _abrirDialogoRecuperarSenha(context),
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Color(0xFF57E6D8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

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
        ],
      ),
    );
  }
}
