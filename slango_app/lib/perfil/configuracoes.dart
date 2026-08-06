import 'package:flutter/material.dart';

import '../service/usuarioService.dart';
import '../login/login.dart';
import 'cores.dart';
import 'texto.dart';
import 'background.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _tipoContaController = TextEditingController();
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    try {
      final usuario = await UsuarioService.buscarUsuarioLogado();
      if (!mounted) return;
      _nomeController.text = usuario.nome;
      _idadeController.text = usuario.idade?.toString() ?? '';
      _tipoContaController.text = usuario.responsavel ? 'Responsável' : 'Jovem';
    } catch (error) {
      _erro = error.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _tipoContaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundEspaco(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                if (_carregando)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_erro != null)
                  Expanded(
                    child: Center(
                      child: Text(
                        _erro!,
                        style: AppText.subtitulo(1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _campoEditavel(
                            label: "Nome",
                            controller: _nomeController,
                          ),
                          const SizedBox(height: 16),
                          _campoEditavel(
                            label: "Idade",
                            controller: _idadeController,
                            teclado: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _campoEditavel(
                            label: "Tipo de conta",
                            controller: _tipoContaController,
                            editavel: false,
                          ),
                          const SizedBox(height: 32),
                          _botaoAcao(
                            texto: "Sair da conta",
                            cor: AppColors.textSecondary,
                            onTap: _sairDaConta,
                          ),
                          const SizedBox(height: 12),
                          _botaoAcao(
                            texto: "Excluir conta",
                            cor: AppColors.danger,
                            onTap: () => _confirmarExclusao(context),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text("Configurações", style: AppText.titulo(0.85)),
      ],
    );
  }

  Widget _campoEditavel({
    required String label,
    required TextEditingController controller,
    TextInputType teclado = TextInputType.text,
    bool editavel = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.cardSubtitulo(0.85)),
                TextField(
                  controller: controller,
                  enabled: editavel,
                  keyboardType: teclado,
                  style: AppText.cardTitulo(0.95),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          if (editavel) const Icon(Icons.edit, color: AppColors.cyan, size: 18),
        ],
      ),
    );
  }

  Widget _botaoAcao({
    required String texto,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(texto, style: AppText.botao(0.95).copyWith(color: cor)),
      ),
    );
  }

  void _sairDaConta() async {
    try {
      await UsuarioService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text("Excluir conta?", style: AppText.cardTitulo(1)),
        content: Text(
          "Essa ação é permanente e vai apagar todo o seu progresso.",
          style: AppText.cardSubtitulo(1),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancelar",
              style: AppText.botao(
                0.85,
              ).copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deletarConta();
            },
            child: Text(
              "Excluir",
              style: AppText.botao(0.85).copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletarConta() async {
    setState(() => _carregando = true);
    try {
      await UsuarioService.deletar();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }
}
