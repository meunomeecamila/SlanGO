import 'package:flutter/material.dart';

import '../inicio/widgets/logo_slango.dart';
import '../login/login.dart';
import '../mapa/mapa.dart';
import '../mapa/styles/texto.dart';
import '../shared/widgets/background_espaco.dart';
import '../shared/widgets/fundo_espacial.dart';
import '../service/usuarioService.dart';
import 'widgets/botao_registrar.dart';
import 'widgets/campo_texto.dart';
import 'widgets/seletor_pergunta_seguranca.dart';
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
  final dataNascimentoController = TextEditingController();
  final respostaSegurancaController = TextEditingController();

  bool ehPai = true;
  bool carregando = false;
  
  // NOVA VARIÁVEL: Controle do aceite dos termos
  bool termosAceitos = false; 

  DateTime? dataNascimento;
  String? perguntaSeguranca;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    dataNascimentoController.dispose();
    respostaSegurancaController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    return "$dia/$mes/$ano";
  }

  Future<void> _selecionarDataNascimento() async {
    final hoje = DateTime.now();

    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime(hoje.year - 10, hoje.month, hoje.day),
      firstDate: DateTime(hoje.year - 100),
      lastDate: hoje,
      helpText: "Selecione a data de nascimento",
      cancelText: "Cancelar",
      confirmText: "Confirmar",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7C5CFF),
              onPrimary: Colors.white,
              surface: Color(0xFF241A3D),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null) {
      setState(() {
        dataNascimento = dataEscolhida;
        dataNascimentoController.text = _formatarData(dataEscolhida);
      });
    }
  }

  // NOVO MÉTODO: Exibir o popup de termos
  void _mostrarPopupTermos() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // Cor de fundo do popup parecida com a da imagem
          backgroundColor: const Color(0xFF2B2244), 
          // Bordas bem arredondadas do card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), 
          ),
          title: const Text(
            'Termos de Responsabilidade',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Ao aceitar, você concorda que seus dados poderão ser utilizados '
            'para fins de pesquisa, análise de dados e melhoria dos serviços, '
            'respeitando a privacidade e a segurança das informações.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.4, // Espaçamento entre as linhas para facilitar a leitura
              fontSize: 15,
            ),
          ),
          // Ajusta o espaçamento dos botões na parte inferior
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16, top: 8), 
          actions: <Widget>[
            // Botão Rejeitar (Apenas texto vermelho/rosado)
            TextButton(
              onPressed: () {
                setState(() {
                  termosAceitos = false; 
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Rejeitar',
                style: TextStyle(color: Color(0xFFF9627D), fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C5CFF), // O mesmo roxo do botão "Criar Conta"
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Formato de pílula
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                setState(() {
                  termosAceitos = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceitar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
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

    if (dataNascimento == null) {
      _mostrarErro("Selecione sua data de nascimento.");
      return;
    }

    if (perguntaSeguranca == null) {
      _mostrarErro("Selecione uma pergunta de segurança.");
      return;
    }

    if (respostaSegurancaController.text.trim().isEmpty) {
      _mostrarErro("Responda a pergunta de segurança.");
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
        dataNascimento: dataNascimento?.toIso8601String().split('T').first,
        perguntaSeguranca: perguntaSeguranca?.trim(),
        respostaSeguranca: respostaSegurancaController.text.trim(),
        emailVerificado: termosAceitos, 
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

                      GestureDetector(
                        onTap: _selecionarDataNascimento,
                        child: AbsorbPointer(
                          child: CampoTexto(
                            label: "Data de nascimento",
                            icon: Icons.cake,
                            controller: dataNascimentoController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SeletorPerguntaSeguranca(
                        perguntaSelecionada: perguntaSeguranca,
                        onChanged: (valor) {
                          setState(() {
                            perguntaSeguranca = valor;
                          });
                        },
                      ),
                      const SizedBox(height: 18),

                      CampoTexto(
                        label: "Resposta",
                        icon: Icons.question_answer,
                        controller: respostaSegurancaController,
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
                      const SizedBox(height: 20),

                      // NOVO WIDGET: Checkbox dos Termos
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white70,
                        ),
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Li e concordo com os termos de uso e responsabilidade.',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          value: termosAceitos,
                          activeColor: const Color(0xFF57E6D8), // Ciano do seu tema
                          checkColor: Colors.black,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? valor) {
                            if (valor == true) {
                              _mostrarPopupTermos();
                            } else {
                              setState(() {
                                termosAceitos = false;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

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
                            style: TextStyle(color: Colors.white70),
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
        ],
      ),
    );
  }
}