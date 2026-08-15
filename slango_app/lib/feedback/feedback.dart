import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../final/Particulas.dart';
import '../mapa/styles/cores.dart';
import '../service/usuarioService.dart';
import '../user/User.dart';
import 'models/sugestao_giria.dart';
import 'services/sugestao_service.dart';

/// Tela unificada de feedback do app.
/// Ordem vertical dos blocos (mantida em todos os cenários):
///   1. Formulário de sugestão de gíria
///   2. Histórico de sugestões do usuário logado
///   3. (Somente admin) Painel de moderação — sugestões pendentes
///   4. Avaliação geral do app (estrelas + comentário) — sempre no final
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  Usuario? _usuarioLogado;
  bool _carregandoUsuario = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    try {
      final u = await UsuarioService.buscarUsuarioLogado();
      if (!mounted) return;
      setState(() {
        _usuarioLogado = u;
        _carregandoUsuario = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregandoUsuario = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _usuarioLogado?.administrador ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Voltar',
        ),
        title: Text(
          'Feedback',
          style: GoogleFonts.alfaSlabOne(
            color: AppColors.text,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: ParticulasFundo(
        child: SafeArea(
          child: _carregandoUsuario
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.cyan),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Formulário de sugestão
                      _FormularioSugestaoCard(
                        aoEnviar: _forcarRebuildHistorico,
                      ),
                      const SizedBox(height: 24),

                      // 2. Histórico do usuário
                      _HistoricoSugestoes(key: _historicoKey),
                      const SizedBox(height: 24),

                      // 3. Moderação — só para admin
                      if (isAdmin) ...[
                        _PainelModeracaoAdmin(
                          nomeAdmin: _usuarioLogado?.nome ?? 'Admin',
                        ),
                        const SizedBox(height: 24),
                      ],

                      // 4. Avaliação geral do app (sempre no final)
                      const _AvaliacaoGeralCard(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Chave do histórico para forçar refresh depois de um envio novo.
  final GlobalKey<_HistoricoSugestoesState> _historicoKey =
      GlobalKey<_HistoricoSugestoesState>();

  void _forcarRebuildHistorico() {
    _historicoKey.currentState?.recarregar();
  }
}

// ─────────────────────────────────────────────────────────────
// 1. FORMULÁRIO DE SUGESTÃO
// ─────────────────────────────────────────────────────────────

class _FormularioSugestaoCard extends StatefulWidget {
  final VoidCallback aoEnviar;
  const _FormularioSugestaoCard({required this.aoEnviar});

  @override
  State<_FormularioSugestaoCard> createState() =>
      _FormularioSugestaoCardState();
}

class _FormularioSugestaoCardState extends State<_FormularioSugestaoCard> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _significado = TextEditingController();
  final _exemplo = TextEditingController();
  final _impactoMotivo = TextEditingController();
  final _classe = TextEditingController();

  String _impacto = 'positiva';
  bool _enviando = false;

  static const _opcoesImpacto = <String>[
    'positiva',
    'negativa',
    'neutra',
    'depende de contexto',
  ];

  @override
  void dispose() {
    _nome.dispose();
    _significado.dispose();
    _exemplo.dispose();
    _impactoMotivo.dispose();
    _classe.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);
    try {
      await SugestaoService.enviar(
        nome: _nome.text.trim(),
        significado: _significado.text.trim(),
        exemplo: _exemplo.text.trim(),
        impacto: _impacto,
        impactoMotivo: _impactoMotivo.text.trim(),
        classeGramatical: _classe.text.trim(),
      );

      if (!mounted) return;
      _formKey.currentState!.reset();
      _nome.clear();
      _significado.clear();
      _exemplo.clear();
      _impactoMotivo.clear();
      _classe.clear();
      setState(() => _impacto = 'positiva');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sugestão enviada! Em breve nossa equipe avalia.'),
          backgroundColor: Colors.green,
        ),
      );
      widget.aoEnviar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      icone: Icons.lightbulb_outline,
      titulo: 'Sugerir uma nova gíria',
      subtitulo: 'Compartilhe uma gíria que ainda não está no SlanGO.',
      corTitulo: AppColors.cyan,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CampoTexto(
              controller: _nome,
              rotulo: 'Nome da gíria',
              dica: 'ex: catfishing',
              validador: _obrigatorio,
            ),
            const SizedBox(height: 12),
            _CampoTexto(
              controller: _significado,
              rotulo: 'Significado',
              dica: 'O que essa gíria quer dizer?',
              linhas: 3,
              validador: _obrigatorio,
            ),
            const SizedBox(height: 12),
            _CampoTexto(
              controller: _exemplo,
              rotulo: 'Exemplo de uso',
              dica: 'Escreva uma frase usando a gíria',
              linhas: 2,
              validador: _obrigatorio,
            ),
            const SizedBox(height: 12),
            _CampoTexto(
              controller: _classe,
              rotulo: 'Classe gramatical',
              dica: 'ex: substantivo, verbo, adjetivo',
              validador: _obrigatorio,
            ),
            const SizedBox(height: 12),
            _DropdownImpacto(
              valor: _impacto,
              opcoes: _opcoesImpacto,
              aoTrocar: (v) => setState(() => _impacto = v ?? 'positiva'),
            ),
            const SizedBox(height: 12),
            _CampoTexto(
              controller: _impactoMotivo,
              rotulo: 'Por que esse impacto?',
              dica: 'Explique o motivo (positiva/negativa/etc)',
              linhas: 3,
              validador: _obrigatorio,
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _enviando ? null : _enviar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _enviando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white),
                label: Text(
                  _enviando ? 'Enviando...' : 'Enviar sugestão',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _obrigatorio(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null;
}

// ─────────────────────────────────────────────────────────────
// 2. HISTÓRICO DE SUGESTÕES DO USUÁRIO
// ─────────────────────────────────────────────────────────────

class _HistoricoSugestoes extends StatefulWidget {
  const _HistoricoSugestoes({super.key});

  @override
  State<_HistoricoSugestoes> createState() => _HistoricoSugestoesState();
}

class _HistoricoSugestoesState extends State<_HistoricoSugestoes> {
  late Future<List<SugestaoGiria>> _future;

  @override
  void initState() {
    super.initState();
    _future = SugestaoService.minhas();
  }

  void recarregar() {
    setState(() {
      _future = SugestaoService.minhas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      icone: Icons.history_rounded,
      titulo: 'Minhas sugestões',
      subtitulo: 'Acompanhe o status de cada gíria que você enviou.',
      corTitulo: AppColors.primaryLight,
      child: FutureBuilder<List<SugestaoGiria>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
          if (snap.hasError) {
            return _MensagemErroInline(
              texto:
                  'Não foi possível carregar o histórico:\n${snap.error.toString().replaceAll('Exception: ', '')}',
              aoTentarNovamente: recarregar,
            );
          }
          final lista = snap.data ?? [];
          if (lista.isEmpty) {
            return const _EstadoVazio(
              texto: 'Você ainda não enviou nenhuma sugestão.',
              icone: Icons.emoji_objects_outlined,
            );
          }
          return Column(
            children: [
              for (final s in lista) ...[
                _CardHistoricoSugestao(sugestao: s),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CardHistoricoSugestao extends StatelessWidget {
  final SugestaoGiria sugestao;
  const _CardHistoricoSugestao({required this.sugestao});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  sugestao.nome.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _SeloStatus(status: sugestao.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            sugestao.significado,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          if (sugestao.foiAvaliada) ...[
            const SizedBox(height: 12),
            _RespostaAdmin(
              descricaoAdm: sugestao.descricaoAdm ?? '',
              quemAceitou: sugestao.quemAceitou ?? '',
              status: sugestao.status,
            ),
          ],
        ],
      ),
    );
  }
}

class _SeloStatus extends StatelessWidget {
  final StatusSugestao status;
  const _SeloStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color cor;
    late IconData icone;
    switch (status) {
      case StatusSugestao.pendente:
        cor = const Color(0xFFF59E0B); // âmbar
        icone = Icons.hourglass_top_rounded;
        break;
      case StatusSugestao.aprovado:
        cor = const Color(0xFF4ADE80); // verde
        icone = Icons.check_circle_rounded;
        break;
      case StatusSugestao.rejeitado:
        cor = const Color(0xFFF87171); // vermelho
        icone = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor.withOpacity(0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 14),
          const SizedBox(width: 5),
          Text(
            status.rotulo,
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.bold,
              fontSize: 11.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _RespostaAdmin extends StatelessWidget {
  final String descricaoAdm;
  final String quemAceitou;
  final StatusSugestao status;

  const _RespostaAdmin({
    required this.descricaoAdm,
    required this.quemAceitou,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final corBorda = status == StatusSugestao.aprovado
        ? const Color(0xFF4ADE80)
        : const Color(0xFFF87171);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_moon_outlined,
                  size: 15, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text(
                'Observação da equipe',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            descricaoAdm.isEmpty ? '—' : descricaoAdm,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          if (quemAceitou.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Avaliado por: $quemAceitou',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 3. PAINEL DE MODERAÇÃO (só admin)
// ─────────────────────────────────────────────────────────────

class _PainelModeracaoAdmin extends StatefulWidget {
  final String nomeAdmin;
  const _PainelModeracaoAdmin({required this.nomeAdmin});

  @override
  State<_PainelModeracaoAdmin> createState() => _PainelModeracaoAdminState();
}

class _PainelModeracaoAdminState extends State<_PainelModeracaoAdmin> {
  late Future<List<SugestaoGiria>> _future;

  @override
  void initState() {
    super.initState();
    _future = SugestaoService.pendentes();
  }

  void _recarregar() {
    setState(() {
      _future = SugestaoService.pendentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      icone: Icons.verified_user_outlined,
      titulo: 'Moderação de sugestões',
      subtitulo:
          'Aprove ou recuse gírias enviadas pelos usuários. A observação é obrigatória.',
      corTitulo: AppColors.cyan,
      child: FutureBuilder<List<SugestaoGiria>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.cyan),
              ),
            );
          }
          if (snap.hasError) {
            return _MensagemErroInline(
              texto:
                  'Erro ao carregar sugestões pendentes:\n${snap.error.toString().replaceAll('Exception: ', '')}',
              aoTentarNovamente: _recarregar,
            );
          }
          final pendentes = snap.data ?? [];
          if (pendentes.isEmpty) {
            return const _EstadoVazio(
              texto: 'Nenhuma sugestão pendente por enquanto. 🎉',
              icone: Icons.check_circle_outline,
            );
          }
          return Column(
            children: [
              for (final s in pendentes) ...[
                _CardModeracao(
                  sugestao: s,
                  aoModerar: _recarregar,
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CardModeracao extends StatefulWidget {
  final SugestaoGiria sugestao;
  final VoidCallback aoModerar;

  const _CardModeracao({
    required this.sugestao,
    required this.aoModerar,
  });

  @override
  State<_CardModeracao> createState() => _CardModeracaoState();
}

class _CardModeracaoState extends State<_CardModeracao> {
  final _observacao = TextEditingController();
  bool _processando = false;

  @override
  void dispose() {
    _observacao.dispose();
    super.dispose();
  }

  bool get _podeConfirmar => _observacao.text.trim().isNotEmpty && !_processando;

  Future<void> _decidir(StatusSugestao decisao) async {
    setState(() => _processando = true);
    try {
      await SugestaoService.moderar(
        idSugestao: widget.sugestao.id,
        decisao: decisao,
        descricaoAdm: _observacao.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            decisao == StatusSugestao.aprovado
                ? 'Gíria aprovada.'
                : 'Gíria recusada.',
          ),
          backgroundColor:
              decisao == StatusSugestao.aprovado ? Colors.green : Colors.redAccent,
        ),
      );
      widget.aoModerar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sugestao;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cyan.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.nome.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if ((s.proponenteNome ?? '').isNotEmpty)
                Text(
                  'por ${s.proponenteNome}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _LinhaCampoLeitura(rotulo: 'Significado', valor: s.significado),
          _LinhaCampoLeitura(rotulo: 'Exemplo', valor: s.exemplo),
          _LinhaCampoLeitura(rotulo: 'Classe', valor: s.classeGramatical),
          _LinhaCampoLeitura(rotulo: 'Impacto', valor: s.impacto),
          _LinhaCampoLeitura(
              rotulo: 'Por que esse impacto?', valor: s.impactoMotivo),
          const SizedBox(height: 12),
          TextField(
            controller: _observacao,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(
              hintText:
                  'Observação obrigatória (feedback ao usuário sobre a decisão)',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.25),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cyan),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _podeConfirmar
                      ? () => _decidir(StatusSugestao.rejeitado)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF87171),
                    side: BorderSide(
                      color: _podeConfirmar
                          ? const Color(0xFFF87171)
                          : Colors.white24,
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text(
                    'Recusar',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _podeConfirmar
                      ? () => _decidir(StatusSugestao.aprovado)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ADE80),
                    disabledBackgroundColor:
                        const Color(0xFF4ADE80).withOpacity(0.35),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: _processando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: const Text(
                    'Aceitar',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          if (!_podeConfirmar && !_processando) ...[
            const SizedBox(height: 6),
            const Text(
              'Preencha a observação para liberar os botões.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LinhaCampoLeitura extends StatelessWidget {
  final String rotulo;
  final String valor;
  const _LinhaCampoLeitura({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    if (valor.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 13,
            height: 1.35,
          ),
          children: [
            TextSpan(
              text: '$rotulo: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
              ),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4. AVALIAÇÃO GERAL DO APP (sempre no final)
// ─────────────────────────────────────────────────────────────

class _AvaliacaoGeralCard extends StatefulWidget {
  const _AvaliacaoGeralCard();

  @override
  State<_AvaliacaoGeralCard> createState() => _AvaliacaoGeralCardState();
}

class _AvaliacaoGeralCardState extends State<_AvaliacaoGeralCard> {
  int _nota = 0;
  final _comentario = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  Future<void> _enviarAvaliacao() async {
    if (_nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escolha uma nota antes de enviar'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() => _enviando = true);
    // Persistência estática por enquanto (mesmo comportamento anterior desta seção).
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _enviando = false;
      _nota = 0;
      _comentario.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Obrigado pelo seu feedback!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      icone: Icons.rate_review_outlined,
      titulo: 'Avaliação geral do app',
      subtitulo: 'Como está sendo sua experiência com o SlanGO?',
      corTitulo: AppColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final ativa = i < _nota;
              return IconButton(
                onPressed: () => setState(() => _nota = i + 1),
                icon: Icon(
                  ativa ? Icons.star : Icons.star_border,
                  color: ativa ? AppColors.cyan : AppColors.textSecondary,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _comentario,
              maxLines: 4,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText:
                    'Escreva uma sugestão, elogio ou problema encontrado...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
                contentPadding: EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _enviando ? null : _enviarAvaliacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _enviando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Enviar feedback',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// UI HELPERS — cartão de seção, campos e estados vazios/erros
// ─────────────────────────────────────────────────────────────

class _SecaoCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final Color corTitulo;
  final Widget child;

  const _SecaoCard({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.corTitulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icone, color: corTitulo, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitulo,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String rotulo;
  final String? dica;
  final int linhas;
  final String? Function(String?)? validador;

  const _CampoTexto({
    required this.controller,
    required this.rotulo,
    this.dica,
    this.linhas = 1,
    this.validador,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: linhas,
      style: const TextStyle(color: AppColors.text),
      validator: validador,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        labelStyle: const TextStyle(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.25),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorStyle: const TextStyle(color: Color(0xFFF87171)),
      ),
    );
  }
}

class _DropdownImpacto extends StatelessWidget {
  final String valor;
  final List<String> opcoes;
  final ValueChanged<String?> aoTrocar;

  const _DropdownImpacto({
    required this.valor,
    required this.opcoes,
    required this.aoTrocar,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Impacto/sentimento',
        labelStyle: const TextStyle(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.25),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: valor,
          isExpanded: true,
          dropdownColor: AppColors.card,
          iconEnabledColor: AppColors.primaryLight,
          style: const TextStyle(color: AppColors.text, fontSize: 14),
          items: opcoes
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: aoTrocar,
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  final String texto;
  final IconData icone;
  const _EstadoVazio({required this.texto, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icone, color: AppColors.primaryLight, size: 28),
          const SizedBox(height: 8),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MensagemErroInline extends StatelessWidget {
  final String texto;
  final VoidCallback aoTentarNovamente;
  const _MensagemErroInline({
    required this.texto,
    required this.aoTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFF87171), fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: aoTentarNovamente,
          icon: const Icon(Icons.refresh, color: AppColors.primaryLight),
          label: const Text(
            'Tentar novamente',
            style: TextStyle(color: AppColors.primaryLight),
          ),
        ),
      ],
    );
  }
}
