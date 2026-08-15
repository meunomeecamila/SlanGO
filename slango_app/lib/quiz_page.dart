import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fase/fase.dart';
import 'licao.dart';
import 'mapa/mapa.dart';
import 'missao/data/mundo_assets.dart';
import 'service/MundoService.dart';
import 'shared/widgets/fundo_espacial.dart';

// ─────────────────────────────────────────────
// QuizPage — carrega as perguntas e controla o fluxo
// ─────────────────────────────────────────────
class QuizPage extends StatefulWidget {
  final String nomeMundo;

  /// Perguntas já carregadas pela LicaoPage. Quando fornecidas, o QuizPage
  /// usa esses dados diretamente sem fazer uma nova chamada ao endpoint,
  /// garantindo que lição e quiz usem as mesmas gírias sorteadas.
  final List<Fase>? perguntasPrecarregadas;

  /// Telas de explicação (uma por gíria). Não fazem parte do fluxo padrão:
  /// aparecem apenas quando o jogador erra uma questão daquela gíria.
  final List<Fase>? explicacoesPrecarregadas;

  const QuizPage({
    super.key,
    required this.nomeMundo,
    this.perguntasPrecarregadas,
    this.explicacoesPrecarregadas,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Fase>> _futurePerguntas;
  List<Fase> _explicacoes = const [];

  /// Reordena as perguntas agrupando por gíria e, dentro de cada gíria,
  /// seguindo a ordem fixa: significado → impacto → aplicação.
  /// Garante a ordem correta independentemente de como o backend devolveu.
  List<Fase> _ordenarPorGiria(List<Fase> perguntas) {
    const prioridade = {'significado': 0, 'impacto': 1, 'aplicacao': 2};

    final grupos = <String, List<Fase>>{};
    final ordemGirias = <String>[];

    for (final pergunta in perguntas) {
      final chave = pergunta.giriaId.toString();
      if (!grupos.containsKey(chave)) {
        grupos[chave] = [];
        ordemGirias.add(chave);
      }
      grupos[chave]!.add(pergunta);
    }

    return ordemGirias.expand((chave) {
      final grupo = [...grupos[chave]!];
      grupo.sort((a, b) {
        final pa = prioridade[a.tipo] ?? 99;
        final pb = prioridade[b.tipo] ?? 99;
        return pa.compareTo(pb);
      });
      return grupo;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _explicacoes = widget.explicacoesPrecarregadas ?? const [];
    if (widget.perguntasPrecarregadas != null) {
      _futurePerguntas =
          Future.value(_ordenarPorGiria(widget.perguntasPrecarregadas!));
    } else {
      _futurePerguntas = MundoService.buscarRodada(widget.nomeMundo).then(
        (rodada) {
          _explicacoes = rodada.fases;
          return _ordenarPorGiria(rodada.todasAsPerguntas);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fase>>(
      future: _futurePerguntas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C5CFF)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1F1035),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Erro ao carregar quiz:\n${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final perguntas = snapshot.data ?? [];

        if (perguntas.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(
              child: Text(
                'Nenhuma pergunta encontrada.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return _QuizRunner(
          perguntas: perguntas,
          nomeMundo: widget.nomeMundo,
          explicacoes: _explicacoes,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// _QuizRunner — o quiz em si (stateful)
// ─────────────────────────────────────────────
enum _EstadoResposta { aguardando, respondido }

class _QuizRunner extends StatefulWidget {
  final List<Fase> perguntas;
  final String nomeMundo;
  final List<Fase> explicacoes;

  const _QuizRunner({
    required this.perguntas,
    required this.nomeMundo,
    this.explicacoes = const [],
  });

  @override
  State<_QuizRunner> createState() => _QuizRunnerState();
}

class _QuizRunnerState extends State<_QuizRunner>
    with SingleTickerProviderStateMixin {
  int _indice = 0;
  int _acertos = 0;
  int _erros = 0;
  String? _selecionada;
  _EstadoResposta _estado = _EstadoResposta.aguardando;

  /// Explicação pendente (tela de lição exibida como feedback de erro).
  Fase? _explicacaoPendente;

  late final AnimationController _feedbackController;
  late final Animation<Offset> _feedbackSlide;
  late final ScrollController _alternativasController;

  // Cores — mesmas do resto do app
  static const Color bgTop = Color(0xFF130A24);
  static const Color bgBottom = Color(0xFF1F1035);
  static const Color cardColor = Color(0xFF2A1B47);
  static const Color cardDark = Color(0xFF241640);
  static const Color roxo = Color(0xFF7C5CFF);
  static const Color roxoClaro = Color(0xFFB9A6FF);
  static const Color verde = Color(0xFF4ADE80);
  static const Color vermelho = Color(0xFFF87171);

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _feedbackSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOut),
    );
    _alternativasController = ScrollController();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _alternativasController.dispose();
    super.dispose();
  }

  void _responder(String textoSelecionado) {
    if (_estado == _EstadoResposta.respondido) return;

    final fasAtual = widget.perguntas[_indice];
    final correta = fasAtual.alternativas
        .firstWhere((a) => a.texto == textoSelecionado)
        .correta;

    setState(() {
      _selecionada = textoSelecionado;
      _estado = _EstadoResposta.respondido;
      if (correta) {
        _acertos++;
      } else {
        _erros++;
      }
    });

    _feedbackController.forward(from: 0);

    // Rola até o final para revelar a caixa de impacto_motivo, quando houver.
    if (fasAtual.isImpacto) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_alternativasController.hasClients) return;
        _alternativasController.animateTo(
          _alternativasController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _avancar() {
    _feedbackController.reverse().then((_) {
      final explicacao = _explicacaoDeErroPendente();
      if (explicacao != null) {
        setState(() {
          _explicacaoPendente = explicacao;
        });
        return;
      }
      _irParaProxima();
    });
  }

  /// Retorna a explicação da gíria atual sempre que a resposta foi errada.
  /// A tela é exibida a cada erro — inclusive quando a mesma gíria é
  /// respondida errado mais de uma vez (Significado, Impacto ou Aplicação).
  Fase? _explicacaoDeErroPendente() {
    final atual = widget.perguntas[_indice];
    final correta = atual.alternativas.firstWhere((a) => a.correta).texto;
    if (_selecionada == correta) return null;

    final idGiria = atual.giriaId.toString();

    // Tenta casar por giriaId e, como fallback, pelo nome da gíria —
    // protege contra divergência de tipos (int vs string) entre backend e app.
    for (final e in widget.explicacoes) {
      if (e.giriaId.toString() == idGiria ||
          e.giria.trim().toLowerCase() == atual.giria.trim().toLowerCase()) {
        return e;
      }
    }

    // Sem explicação dedicada: usa a própria questão de significado da gíria
    // (que carrega explicacao + exemplo) como tela de revisão.
    return widget.perguntas.firstWhere(
      (p) =>
          p.giriaId.toString() == idGiria &&
          p.tipo == 'significado' &&
          p.explicacao.trim().isNotEmpty,
      orElse: () => atual,
    );
  }

  /// Fecha a tela de explicação e continua exatamente de onde parou.
  void _fecharExplicacao() {
    setState(() => _explicacaoPendente = null);
    _irParaProxima();
  }

  void _irParaProxima() {
    if (_indice < widget.perguntas.length - 1) {
      setState(() {
        _indice++;
        _selecionada = null;
        _estado = _EstadoResposta.aguardando;
      });
    } else {
      _mostrarResultado();
    }
  }

  void _mostrarResultado() async {
    final idsUnicos = widget.perguntas
        .map((fase) => fase.giriaId.toString())
        .toSet()
        .toList();

    try {
      await MundoService.validarResultado(
        nomeDoMundo: widget.nomeMundo,
        pontuacaoFinal: _acertos,
        girias: idsUnicos,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao salvar resultado: $e');
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _ResultadoScreen(
          acertos: _acertos,
          total: widget.perguntas.length,
          nomeMundo: widget.nomeMundo,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  // Volta para o mapa (usado pelo cabeçalho e pelo botão físico de voltar)
  void _voltarParaMapa() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MapaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.9, 1.25);
    final double heightScale = (size.height / 844).clamp(0.85, 1.35);

    final explicacao = _explicacaoPendente;
    if (explicacao != null) {
      return PopScope(
        canPop: false,
        child: SlangQuizScreen(
          palavra: explicacao.giria,
          classe: explicacao.classe ?? '',
          significado: explicacao.explicacao,
          exemplo: explicacao.exemplo,
          usageHighlight: explicacao.exemplo,
          avatar: petDoMundo(widget.nomeMundo),
          cntCorreto: _acertos,
          cntErrado: _erros,
          progresso: (_indice + 1) / widget.perguntas.length,
          onClose: _fecharExplicacao,
          onContinue: _fecharExplicacao,
        ),
      );
    }

    final fase = widget.perguntas[_indice];
    final total = widget.perguntas.length;
    final progresso = (_indice + 1) / total;

    final respostaCorreta = fase.alternativas
        .firstWhere((a) => a.correta)
        .texto;
    final acertou = _selecionada == respostaCorreta;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _voltarParaMapa();
      },
      child: Scaffold(
        backgroundColor: bgBottom,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgTop, bgBottom],
                ),
              ),
            ),
            const Positioned.fill(child: FundoEspacial(interativo: false)),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12 * heightScale),

                    _buildTopBar(scale, progresso),
                    SizedBox(height: 22 * heightScale),

                    // Badge do número da pergunta
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14 * scale,
                          vertical: 6 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: roxo.withOpacity(0.12),
                          border: Border.all(color: roxo.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Pergunta ${_indice + 1} de $total',
                          style: TextStyle(
                            color: roxoClaro,
                            fontWeight: FontWeight.bold,
                            fontSize: 12 * scale,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * heightScale),

                    // Gíria em destaque
                    Text(
                      fase.giria.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alfaSlabOne(
                        color: Colors.white,
                        fontSize: 40 * scale,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: roxo.withOpacity(0.6),
                            blurRadius: 6 * scale,
                          ),
                          Shadow(
                            color: roxo.withOpacity(0.35),
                            blurRadius: 18 * scale,
                          ),
                          Shadow(
                            color: roxoClaro.withOpacity(0.2),
                            blurRadius: 32 * scale,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16 * heightScale),

                    // Card com o texto da pergunta
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18 * scale),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        fase.pergunta,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.5 * scale,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * heightScale),

                    // Lista de alternativas + caixinha de impacto_motivo
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _alternativasController,
                        padding: EdgeInsets.only(
                          bottom: _estado == _EstadoResposta.respondido
                              ? 160 * scale
                              : 16 * scale,
                        ),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0;
                                i < fase.alternativas.length;
                                i++) ...[
                              if (i > 0) SizedBox(height: 12 * scale),
                              _buildAlternativa(
                                fase.alternativas[i],
                                letra: String.fromCharCode(65 + i),
                                scale: scale,
                                heightScale: heightScale,
                                respostaCorreta: respostaCorreta,
                              ),
                            ],
                            if (_estado == _EstadoResposta.respondido &&
                                fase.isImpacto &&
                                fase.impactoMotivo.trim().isNotEmpty) ...[
                              SizedBox(height: 16 * scale),
                              _buildImpactoMotivoCard(
                                fase.impactoMotivo,
                                scale,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_estado == _EstadoResposta.respondido)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _feedbackSlide,
                  child: _buildFeedbackPanel(
                    acertou: acertou,
                    respostaCorreta: respostaCorreta,
                    scale: scale,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Barra superior: seta de voltar + "Mapa" + progresso + pontuação ───
  Widget _buildTopBar(double scale, double progresso) {
    return Row(
      children: [
        GestureDetector(
          onTap: _voltarParaMapa,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10 * scale,
              vertical: 6 * scale,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: roxoClaro,
                  size: 15,
                ),
                SizedBox(width: 5 * scale),
                Text(
                  'Mapa',
                  style: TextStyle(
                    color: roxoClaro,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5 * scale,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 14 * scale),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progresso.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: cardColor,
              valueColor: const AlwaysStoppedAnimation<Color>(roxo),
            ),
          ),
        ),
        SizedBox(width: 14 * scale),
        Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: verde, size: 17),
            const SizedBox(width: 4),
            Text(
              '$_acertos',
              style: const TextStyle(color: verde, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.cancel_rounded, color: vermelho, size: 17),
            const SizedBox(width: 4),
            Text(
              '$_erros',
              style: const TextStyle(
                color: vermelho,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Botão de alternativa (com letra A/B/C/D à esquerda) ───
  Widget _buildAlternativa(
    Alternativa alt, {
    required String letra,
    required double scale,
    required double heightScale,
    required String respostaCorreta,
  }) {
    Color borderColor = Colors.white.withOpacity(0.08);
    Color bgColor = cardDark;
    Color textColor = Colors.white;
    Color letraCor = roxoClaro;
    Color letraBg = roxo.withOpacity(0.15);
    Widget? trailingIcon;

    if (_estado == _EstadoResposta.respondido) {
      if (alt.correta) {
        borderColor = verde;
        bgColor = verde.withOpacity(0.13);
        textColor = verde;
        letraCor = verde;
        letraBg = verde.withOpacity(0.18);
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: verde,
          size: 20,
        );
      } else if (alt.texto == _selecionada) {
        borderColor = vermelho;
        bgColor = vermelho.withOpacity(0.11);
        textColor = vermelho;
        letraCor = vermelho;
        letraBg = vermelho.withOpacity(0.18);
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: vermelho,
          size: 20,
        );
      }
    }

    final bool tocavel = _estado == _EstadoResposta.aguardando;

    final Widget botao = GestureDetector(
      onTap: tocavel ? () => _responder(alt.texto) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14 * scale,
          vertical: 12 * scale,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 28 * scale,
              height: 28 * scale,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: letraBg,
                shape: BoxShape.circle,
              ),
              child: Text(
                letra,
                style: TextStyle(
                  color: letraCor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13 * scale,
                ),
              ),
            ),
            SizedBox(width: 12 * scale),
            Expanded(
              child: Text(
                alt.texto,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.5 * scale,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon,
            ],
          ],
        ),
      ),
    );

    return botao;
  }

  // ─── Caixinha "Por que esse impacto?" — segue o Design System dos
  // demais componentes de feedback (cardDark + borda roxo claro + tipografia).
  // Aparece uma única vez, abaixo das alternativas, sempre que a questão
  // de impacto é respondida (acertando ou errando).
  Widget _buildImpactoMotivoCard(String motivo, double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14 * scale),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: roxoClaro.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: roxo.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: roxoClaro,
                size: 16 * scale,
              ),
              SizedBox(width: 6 * scale),
              Text(
                'Por que esse impacto?',
                style: TextStyle(
                  color: roxoClaro,
                  fontWeight: FontWeight.bold,
                  fontSize: 13 * scale,
                ),
              ),
            ],
          ),
          SizedBox(height: 6 * scale),
          Text(
            motivo,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5 * scale,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Painel de feedback na base ───
  Widget _buildFeedbackPanel({
    required bool acertou,
    required String respostaCorreta,
    required double scale,
  }) {
    final Color cor = acertou ? verde : vermelho;
    final Color bg = acertou
        ? const Color(0xFF0F3D25)
        : const Color(0xFF3D0F15);
    final String titulo = acertou ? 'Correto! 🎉' : 'Errado!';
    final String sub = acertou
        ? 'Boa! Continue assim.'
        : 'Resposta: $respostaCorreta';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20 * scale,
        20 * scale,
        20 * scale,
        32 * scale,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: cor.withOpacity(0.5), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            acertou ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: cor,
            size: 36 * scale,
          ),
          SizedBox(width: 14 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: cor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * scale,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    color: cor.withOpacity(0.85),
                    fontSize: 13 * scale,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12 * scale),
          SizedBox(
            height: 44 * scale,
            child: ElevatedButton(
              onPressed: _avancar,
              style: ElevatedButton.styleFrom(
                backgroundColor: cor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.symmetric(horizontal: 22 * scale),
                elevation: 0,
              ),
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * scale,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _ResultadoScreen — tela final com feedback proporcional ao desempenho
// ─────────────────────────────────────────────
class _ResultadoScreen extends StatelessWidget {
  final int acertos;
  final int total;
  final String nomeMundo;

  const _ResultadoScreen({
    required this.acertos,
    required this.total,
    required this.nomeMundo,
  });

  static const Color bgTop = Color(0xFF0E0821);
  static const Color bgBottom = Color(0xFF1B0F33);
  static const Color cardColor = Color(0xFF241640);
  static const Color roxo = Color(0xFF7C5CFF);
  static const Color roxoClaro = Color(0xFFB9A6FF);
  static const Color verde = Color(0xFF4ADE80);
  static const Color verdeAgua = Color(0xFF5DD39E);
  static const Color vermelho = Color(0xFFF87171);

  int get _erros => total - acertos;

  double get _pct => total == 0 ? 0.0 : acertos / total;

  Color get _corResultado {
    if (_pct >= 0.8) return verdeAgua;
    if (_pct >= 0.5) return roxo;
    return vermelho;
  }

  String get _emoji {
    if (_pct >= 0.8) return '🎉';
    if (_pct >= 0.5) return '🚀';
    return '🌱';
  }

  String get _titulo {
    if (_pct == 1.0) return 'Perfeito, Astronauta!';
    if (_pct >= 0.8) return 'Parabéns, Astronauta!';
    if (_pct >= 0.5) return 'Bom começo Astronauta! Vamos melhorar';
    return 'Vamos melhorar juntos, Astronauta!';
  }

  String get _mensagem {
    if (_pct == 1.0) return 'Você mandou muito bem nessa jornada!';
    if (_pct >= 0.8) return 'Você foi muito bem nessa jornada!';
    if (_pct >= 0.5) return 'Bom esforço! Revise as gírias que errou e tente de novo.';
    return 'Toda jornada começa com um passo. Que tal revisar a lição e tentar outra vez?';
  }

  String get _nomeMundoFormatado => nomeMundo.isEmpty
      ? ''
      : '${nomeMundo[0].toUpperCase()}${nomeMundo.substring(1)}';

  int get _estrelas => (1 + (_pct * 4)).clamp(1, 5).round();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.9, 1.25);
    final double heightScale = (size.height / 844).clamp(0.85, 1.35);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MapaScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: bgBottom,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgTop, bgBottom],
                ),
              ),
            ),
            const Positioned.fill(child: FundoEspacial(interativo: false)),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20 * scale,
                      10 * heightScale,
                      20 * scale,
                      0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 32 * scale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_nomeMundoFormatado.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14 * scale,
                                vertical: 6 * scale,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: roxo.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                'Mundo $_nomeMundoFormatado',
                                style: TextStyle(
                                  color: roxoClaro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5 * scale,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MapaScreen(),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14 * scale,
                                  vertical: 6 * scale,
                                ),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: roxo.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: roxoClaro,
                                      size: 13 * scale,
                                    ),
                                    SizedBox(width: 6 * scale),
                                    Text(
                                      'Mapa',
                                      style: TextStyle(
                                        color: roxoClaro,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5 * scale,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 26 * scale,
                              vertical: 20 * heightScale,
                            ),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 550),
                              curve: Curves.easeOutCubic,
                              builder: (context, valor, child) {
                                return Opacity(
                                  opacity: valor,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - valor) * 24),
                                    child: child,
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Text(
                                      _emoji,
                                      style: TextStyle(fontSize: 46 * scale),
                                    ),
                                  ),
                                  SizedBox(height: 14 * heightScale),

                                  Text(
                                    _titulo,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.baloo2(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 24 * scale,
                                    ),
                                  ),

                                  SizedBox(height: 26 * heightScale),

                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20 * scale,
                                      vertical: 26 * scale,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(26),
                                      border: Border.all(
                                        color: _corResultado.withOpacity(0.35),
                                        width: 1.4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _corResultado.withOpacity(0.18),
                                          blurRadius: 26,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _buildPlacarItem(
                                              icon: Icons.check_circle_rounded,
                                              cor: verde,
                                              valor: acertos,
                                              label: 'Acertos',
                                              scale: scale,
                                            ),
                                            SizedBox(width: 18 * scale),
                                            Container(
                                              width: 1,
                                              height: 44 * scale,
                                              color: Colors.white12,
                                            ),
                                            SizedBox(width: 18 * scale),
                                            _buildPlacarItem(
                                              icon: Icons.cancel_rounded,
                                              cor: vermelho,
                                              valor: _erros,
                                              label: 'Erros',
                                              scale: scale,
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 16 * scale),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            value: _pct,
                                            minHeight: 8,
                                            backgroundColor: Colors.white10,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              _corResultado,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8 * scale),
                                        Text(
                                          '${(_pct * 100).round()}% de aproveitamento',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12 * scale,
                                          ),
                                        ),

                                        SizedBox(height: 14 * scale),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(5, (i) {
                                            final preenchida = i < _estrelas;
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 2 * scale,
                                              ),
                                              child: Icon(
                                                preenchida
                                                    ? Icons.star_rounded
                                                    : Icons.star_border_rounded,
                                                color: preenchida
                                                    ? verdeAgua
                                                    : Colors.white24,
                                                size: 22 * scale,
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20 * heightScale),

                                  Text(
                                    _mensagem,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.5 * scale,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacarItem({
    required IconData icon,
    required Color cor,
    required int valor,
    required String label,
    required double scale,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: cor, size: 26 * scale),
        SizedBox(height: 6 * scale),
        Text(
          '$valor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22 * scale,
          ),
        ),
        SizedBox(height: 2 * scale),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11.5 * scale),
        ),
      ],
    );
  }
}