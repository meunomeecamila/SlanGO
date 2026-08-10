import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';
import '../texto.dart';
import 'card_certificado_mundo.dart';
import 'certificado_mundo_data.dart';
import 'efeito_confete.dart';
import 'painel_certificado.dart';

/// Conteúdo da aba "Certificados" do perfil.
/// Lista um card por mundo, usando o progresso real vindo do backend.
///
/// Sempre que um mundo é concluído (progresso = 100%) pela primeira vez
/// desde a última visita a esta tela, ele é exibido no topo da lista.
class AbaCertificados extends StatefulWidget {
  final List<ProgressoMundo> mundos;

  /// Nome do usuário logado, para personalizar a mensagem do certificado
  /// (ex: "Aêêê, Vitor!" em vez de "Aêêê, astronauta!"). Passe null/vazio
  /// para manter o tratamento genérico "astronauta" (ex: sessão de
  /// convidado, ou nome ainda carregando).
  final String? nomeUsuario;

  const AbaCertificados({
    super.key,
    required this.mundos,
    this.nomeUsuario,
  });

  @override
  State<AbaCertificados> createState() => _AbaCertificadosState();
}

class _AbaCertificadosState extends State<AbaCertificados> {
  static const _chavePrefs = 'certificados_ja_vistos_desbloqueados';

  Set<String> _idsJaVistosDesbloqueados = {};
  bool _carregado = false;

  @override
  void initState() {
    super.initState();
    _carregarEReordenar();
  }

  @override
  void didUpdateWidget(covariant AbaCertificados oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se a lista de mundos mudou (ex: progresso atualizado após um quiz),
    // reavalia quem é "recém-liberado" sem perder o que já foi marcado.
    if (oldWidget.mundos != widget.mundos) {
      _atualizarVistosComListaAtual();
    }
  }

  String _idDoMundo(ProgressoMundo mundo) =>
      mundo.id.isNotEmpty ? mundo.id : mundo.nome;

  Future<void> _carregarEReordenar() async {
    final prefs = await SharedPreferences.getInstance();
    final salvos = prefs.getStringList(_chavePrefs) ?? [];

    if (!mounted) return;
    setState(() {
      _idsJaVistosDesbloqueados = salvos.toSet();
      _carregado = true;
    });

    await _salvarDesbloqueadosAtuais(prefs);
  }

  Future<void> _atualizarVistosComListaAtual() async {
    final prefs = await SharedPreferences.getInstance();
    await _salvarDesbloqueadosAtuais(prefs);
    if (mounted) setState(() {});
  }

  Future<void> _salvarDesbloqueadosAtuais(SharedPreferences prefs) async {
    final desbloqueadosAgora = widget.mundos
        .where((m) => m.progresso >= 1.0)
        .map(_idDoMundo)
        .toSet();

    final atualizados = {..._idsJaVistosDesbloqueados, ...desbloqueadosAgora};
    _idsJaVistosDesbloqueados = atualizados;
    await prefs.setStringList(_chavePrefs, atualizados.toList());
  }

  List<ProgressoMundo> _ordenarComRecemLiberadosPrimeiro() {
    final recemLiberados = <ProgressoMundo>[];
    final restante = <ProgressoMundo>[];

    for (final mundo in widget.mundos) {
      final id = _idDoMundo(mundo);
      final desbloqueado = mundo.progresso >= 1.0;
      final jaEraVistoAntes = _idsJaVistosDesbloqueados.contains(id);

      if (desbloqueado && !jaEraVistoAntes) {
        recemLiberados.add(mundo);
      } else {
        restante.add(mundo);
      }
    }

    return [...recemLiberados, ...restante];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mundos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Nenhum mundo explorado ainda. Comece a viagem! 🚀',
            textAlign: TextAlign.center,
            style: AppText.subtitulo(1),
          ),
        ),
      );
    }

    if (!_carregado) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final mundosOrdenados = _ordenarComRecemLiberadosPrimeiro();

    return Column(
      children: mundosOrdenados.map((mundo) {
        final certificado = certificadoDoMundo(
          mundo.id.isNotEmpty ? mundo.id : mundo.nome,
        ).comNomeUsuario(widget.nomeUsuario);

        return CardCertificadoMundo(
          certificado: certificado,
          progresso: mundo.progresso,
          onAbrir: () {
            // Efeito empolgante ao liberar o certificado.
            EfeitoConfete.disparar(
              context,
              cores: [
                certificado.corPrimaria,
                certificado.corSecundaria,
                Colors.white,
              ],
            );
            PainelCertificado.abrir(context, certificado);
          },
        );
      }).toList(),
    );
  }
}