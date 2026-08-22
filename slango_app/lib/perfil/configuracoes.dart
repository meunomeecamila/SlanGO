import 'package:flutter/material.dart';

import '../service/usuarioService.dart';
import '../login/login.dart';
import 'cores.dart';
import 'texto.dart';
import '../final/Particulas.dart';
import '../l10n/l10n.dart';
import '../l10n/locale_controller.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _tipoContaController = TextEditingController();

  DateTime? _dataNascimento;
  DateTime? _dataNascimentoOriginal;
  String? _nomeOriginal;
  bool? _responsavel;
  bool _carregando = true;
  bool _salvando = false;
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
      _nomeOriginal = usuario.nome;
      _dataNascimento = _parseDataNascimento(usuario.dataNascimento);
      _dataNascimentoOriginal = _dataNascimento;
      if (_dataNascimento != null) {
        _dataNascimentoController.text = _formatarData(_dataNascimento!);
      }
      _responsavel = usuario.responsavel;
    } catch (error) {
      _erro = error.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  DateTime? _parseDataNascimento(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;
    final data = DateTime.tryParse(valor);
    return data;
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return "$dia/$mes/${data.year}";
  }

  Future<void> _salvarPerfil() async {
    if (_salvando) return;

    final nomeDigitado = _nomeController.text.trim();
    final temNomeAlterado =
        nomeDigitado.isNotEmpty && nomeDigitado != (_nomeOriginal ?? '');
    final temDataAlterada =
        _dataNascimento != null &&
        (_dataNascimentoOriginal == null ||
            !_dataNascimento!.isAtSameMomentAs(_dataNascimentoOriginal!));

    if (!temNomeAlterado && !temDataAlterada) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noChanges)),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final usuarioAtual = await UsuarioService.buscarUsuarioLogado();
      final atualizado = await UsuarioService.atualizar(
        usuarioAtual.id,
        nome: temNomeAlterado ? nomeDigitado : null,
        dataNascimento: _dataNascimento?.toIso8601String().split('T').first,
      );

      if (!mounted) return;
      _nomeOriginal = atualizado.nome;
      _dataNascimentoOriginal = _parseDataNascimento(atualizado.dataNascimento);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileUpdated)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _selecionarDataNascimento() async {
    final agora = DateTime.now();
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate:
          _dataNascimento ?? DateTime(agora.year - 18, agora.month, agora.day),
      firstDate: DateTime(agora.year - 100),
      lastDate: agora,
      helpText: context.l10n.dateOfBirth,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.cyan,
              onPrimary: Colors.white,
              surface: AppColors.card,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataNascimento = dataEscolhida;
        _dataNascimentoController.text = _formatarData(dataEscolhida);
      });
      await _salvarPerfil();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _tipoContaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tipoContaController.text = (_responsavel ?? false)
        ? context.l10n.guardian
        : context.l10n.youngPerson;
    return Scaffold(
      body: ParticulasFundo(
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
                          Text(context.l10n.general, style: AppText.cardSubtitulo(0.9)),
                          const SizedBox(height: 12),
                          _campoEditavel(
                            label: context.l10n.name,
                            controller: _nomeController,
                          ),
                          const SizedBox(height: 16),
                          _botaoAcao(
                            texto: _salvando
                                ? context.l10n.saving
                                : context.l10n.saveChanges,
                            cor: AppColors.cyan,
                            onTap: _salvando ? null : _salvarPerfil,
                          ),
                          const SizedBox(height: 16),
                          _campoData(),
                          const SizedBox(height: 16),
                          _campoEditavel(
                            label: context.l10n.accountType,
                            controller: _tipoContaController,
                            editavel: false,
                          ),

                          const SizedBox(height: 28),
                          Text(context.l10n.security, style: AppText.cardSubtitulo(0.9)),
                          const SizedBox(height: 12),
                          _linhaAcao(
                            icone: Icons.lock_outline,
                            texto: context.l10n.changePassword,
                            onTap: () => _abrirDialogoSenha(context),
                          ),
                          const SizedBox(height: 12),
                          _linhaAcao(
                            icone: Icons.email_outlined,
                            texto: context.l10n.changeEmail,
                            onTap: () => _abrirDialogoEmail(context),
                          ),

                          const SizedBox(height: 32),
                          _seletorIdioma(context),
                          const SizedBox(height: 12),
                          _botaoAcao(
                            texto: context.l10n.signOut,
                            cor: AppColors.textSecondary,
                            onTap: _sairDaConta,
                          ),
                          const SizedBox(height: 12),
                          _botaoAcao(
                            texto: context.l10n.deleteAccount,
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
        Text(context.l10n.settings, style: AppText.titulo(0.85)),
      ],
    );
  }

  Widget _seletorIdioma(BuildContext context) {
    final l10n = context.l10n;
    final localeController = LocaleControllerScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(l10n.language, style: AppText.cardSubtitulo(0.85)),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: localeController.locale,
              dropdownColor: AppColors.card,
              style: AppText.cardTitulo(0.95),
              iconEnabledColor: AppColors.cyan,
              onChanged: (locale) {
                if (locale != null) localeController.setLocale(locale);
              },
              items: [
                DropdownMenuItem(
                  value: const Locale('pt'),
                  child: Text('🇧🇷 ${l10n.portuguese}'),
                ),
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text('🇺🇸 ${l10n.english}'),
                ),
                DropdownMenuItem(
                  value: const Locale('es'),
                  child: Text('🇪🇸 ${l10n.spanish}'),
                ),
              ],
            ),
          ),
        ],
      ),
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

  /// Campo de "Data de nascimento" — não permite digitação livre,
  /// abre o seletor de data do sistema ao tocar.
  Widget _campoData() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _selecionarDataNascimento,
      child: Container(
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
                  Text(
                    context.l10n.dateOfBirth,
                    style: AppText.cardSubtitulo(0.85),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      _dataNascimentoController.text.isEmpty
                          ? context.l10n.selectDate
                          : _dataNascimentoController.text,
                      style: AppText.cardTitulo(0.95).copyWith(
                        color: _dataNascimentoController.text.isEmpty
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.calendar_today, color: AppColors.cyan, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _linhaAcao({
    required IconData icone,
    required String texto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icone, color: AppColors.cyan, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(texto, style: AppText.cardTitulo(0.95))),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoAcao({
    required String texto,
    required Color cor,
    required VoidCallback? onTap,
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

  void _abrirDialogoSenha(BuildContext context) {
    final senhaAtualController = TextEditingController();
    final novaSenhaController = TextEditingController();
    final confirmarSenhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(context.l10n.changePassword, style: AppText.cardTitulo(1)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _campoDialogo(
              controller: senhaAtualController,
              rotulo: context.l10n.currentPassword,
              oculto: true,
            ),
            const SizedBox(height: 12),
            _campoDialogo(
              controller: novaSenhaController,
              rotulo: context.l10n.newPassword,
              oculto: true,
            ),
            const SizedBox(height: 12),
            _campoDialogo(
              controller: confirmarSenhaController,
              rotulo: context.l10n.confirmNewPassword,
              oculto: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.cancel,
              style: AppText.botao(
                0.85,
              ).copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: validar e enviar a troca de senha pro backend
              Navigator.of(context).pop();
            },
            child: Text(
              context.l10n.save,
              style: AppText.botao(0.85).copyWith(color: AppColors.cyan),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirDialogoEmail(BuildContext context) {
    final novoEmailController = TextEditingController();
    final senhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(context.l10n.changeEmail, style: AppText.cardTitulo(1)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _campoDialogo(
              controller: novoEmailController,
              rotulo: context.l10n.newEmail,
              teclado: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _campoDialogo(
              controller: senhaController,
              rotulo: context.l10n.currentPassword,
              oculto: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.cancel,
              style: AppText.botao(
                0.85,
              ).copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: validar e enviar a troca de e-mail pro backend
              Navigator.of(context).pop();
            },
            child: Text(
              context.l10n.save,
              style: AppText.botao(0.85).copyWith(color: AppColors.cyan),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoDialogo({
    required TextEditingController controller,
    required String rotulo,
    bool oculto = false,
    TextInputType teclado = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: oculto,
      keyboardType: teclado,
      style: AppText.cardTitulo(0.9),
      decoration: InputDecoration(
        labelText: rotulo,
        labelStyle: AppText.cardSubtitulo(0.85),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cyan),
        ),
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
        title: Text(context.l10n.deleteAccountQuestion, style: AppText.cardTitulo(1)),
        content: Text(
          context.l10n.deleteAccountDescription,
          style: AppText.cardSubtitulo(1),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.cancel,
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
              context.l10n.delete,
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
