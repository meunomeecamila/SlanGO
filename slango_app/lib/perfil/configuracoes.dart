import 'package:flutter/material.dart';

import 'cores.dart';
import 'texto.dart';
import 'background.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  // TODO: substituir pelos valores reais vindos do usuário logado.
  final TextEditingController _nomeController = TextEditingController(text: "Mariana");
  final TextEditingController _idadeController = TextEditingController(text: "21");
  final TextEditingController _tipoContaController = TextEditingController(text: "Gratuita");

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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _campoEditavel(label: "Nome", controller: _nomeController),
                        const SizedBox(height: 16),
                        _campoEditavel(
                          label: "Idade",
                          controller: _idadeController,
                          teclado: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _campoEditavel(label: "Tipo de conta", controller: _tipoContaController, editavel: false),
                        const SizedBox(height: 32),
                        _botaoAcao(
                          texto: "Sair da conta",
                          cor: AppColors.textSecondary,
                          onTap: () {
                            // TODO: implementar logout
                          },
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
          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
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
          if (editavel)
            const Icon(Icons.edit, color: AppColors.cyan, size: 18),
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
        child: Text(
          texto,
          style: AppText.botao(0.95).copyWith(color: cor),
        ),
      ),
    );
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
            child: Text("Cancelar", style: AppText.botao(0.85).copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              // TODO: implementar exclusão de conta
              Navigator.of(context).pop();
            },
            child: Text("Excluir", style: AppText.botao(0.85).copyWith(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}