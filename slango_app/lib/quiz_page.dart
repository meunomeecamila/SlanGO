import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fase/fase.dart';
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

  const QuizPage({
    super.key,
    required this.nomeMundo,
    this.perguntasPrecarregadas,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Fase>> _futurePerguntas;

  @override
  void initState() {
    super.initState();
    if (widget.perguntasPrecarregadas != null) {
      // Usa os dados já carregados — sem nova requisição ao servidor.
      _futurePerguntas = Future.value(widget.perguntasPrecarregadas);
    } else {
      _futurePerguntas = MundoService.buscarRodada(
        widget.nomeMundo,
      ).then((rodada) => rodada.todasAsPerguntas);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fase>>(
      future: _futurePerguntas,
      builder: (context, snapshot) {
        // ── Carregando ──
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C5CFF)),
            ),
          );
        }

        // ── Erro ──
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

        return _QuizRunner(perguntas: perguntas, nomeMundo: widget.nomeMundo);
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

  const _QuizRunner({required this.perguntas, required this.nomeMundo});

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

  // Animação do feedback
  late final AnimationController _feedbackController;
  late final Animation<Offset> _feedbackSlide;

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
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // ── Responde uma alternativa ──
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
  }

  // ── Avança para a próxima pergunta ──
  void _avancar() {
    _feedbackController.reverse().then((_) {
      if (_indice < widget.perguntas.length - 1) {
        setState(() {
          _indice++;
          _selecionada = null;
          _estado = _EstadoResposta.aguardando;
        });
      } else {
        _mostrarResultado();
      }
    });
  }

  // ── Tela de resultado final ──
 // ── Tela de resultado final e salvamento ──
  void _mostrarResultado() async {
    // 1. Extrai APENAS os 3 IDs únicos e converte para String
    final idsUnicos = widget.perguntas
        .map((fase) => fase.giriaId.toString()) 
        .toSet() 
        .toList();

    // 2. Envia para o backend
    MundoService.validarResultado(
      nomeDoMundo: widget.nomeMundo,
      pontuacaoFinal: _acertos,
      girias: idsUnicos, // Agora envia exatamente ["1", "2", "3"]
    ).then((resultado) {
      
    }).catchError((erro) {
      
    });

    // 3. Navega para a tela final
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.9, 1.25);
    final double heightScale = (size.height / 844).clamp(0.85, 1.35);

    final fase = widget.perguntas[_indice];
    final total = widget.perguntas.length;
    final progresso = (_indice + 1) / total;

    final respostaCorreta = fase.alternativas
        .firstWhere((a) => a.correta)
        .texto;
    final acertou = _selecionada == respostaCorreta;

    return Scaffold(
      backgroundColor: bgBottom,
      body: Stack(
        children: [
          // ── Fundo gradiente ──
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

          // ── Fundo de constelação animada ──
          const Positioned.fill(child: FundoEspacial(interativo: false)),

          // ── Conteúdo principal ──
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12 * heightScale),

                  // Barra superior (fechar + progresso + pontuação)
                  _buildTopBar(scale, progresso),
                  SizedBox(height: 20 * heightScale),

                  // Badge do número da pergunta
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14 * scale,
                        vertical: 6 * scale,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: roxo.withOpacity(0.6)),
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
                  SizedBox(height: 18 * heightScale),

                  // Gíria em destaque
                  Text(
                    fase.giria.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.alfaSlabOne(
                      color: Colors.white,
                      fontSize: 42 * scale,
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
                  SizedBox(height: 14 * heightScale),

                  // Card com o texto da pergunta
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16 * scale),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      fase.pergunta,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 * scale,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * heightScale),

                  // Lista de alternativas
                  Expanded(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: fase.alternativas.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10 * scale),
                      itemBuilder: (_, i) {
                        final alt = fase.alternativas[i];
                        return _buildAlternativa(
                          alt,
                          scale: scale,
                          heightScale: heightScale,
                          respostaCorreta: respostaCorreta,
                        );
                      },
                    ),
                  ),

                  // Espaço reservado para o painel de feedback
                  SizedBox(
                    height: _estado == _EstadoResposta.respondido
                        ? 100 * scale
                        : 16 * scale,
                  ),
                ],
              ),
            ),
          ),

          // ── Painel de feedback deslizante ──
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
    );
  }

  // ─── Barra superior ───
  Widget _buildTopBar(double scale, double progresso) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.white70, size: 22),
        ),
        const SizedBox(width: 14),
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
        const SizedBox(width: 14),
        Row(
          children: [
            const Icon(Icons.check, color: verde, size: 18),
            const SizedBox(width: 4),
            Text(
              '$_acertos',
              style: const TextStyle(color: verde, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 14),
            const Icon(Icons.close, color: vermelho, size: 18),
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

  // ─── Botão de alternativa ───
  Widget _buildAlternativa(
    Alternativa alt, {
    required double scale,
    required double heightScale,
    required String respostaCorreta,
  }) {
    Color borderColor = Colors.white.withOpacity(0.08);
    Color bgColor = cardDark;
    Color textColor = Colors.white;
    Widget? trailingIcon;

    if (_estado == _EstadoResposta.respondido) {
      if (alt.correta) {
        // Sempre destaca a correta em verde
        borderColor = verde;
        bgColor = verde.withOpacity(0.15);
        textColor = verde;
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: verde,
          size: 20,
        );
      } else if (alt.texto == _selecionada) {
        // A errada que foi selecionada fica vermelha
        borderColor = vermelho;
        bgColor = vermelho.withOpacity(0.12);
        textColor = vermelho;
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: vermelho,
          size: 20,
        );
      }
    }

    final bool tocavel = _estado == _EstadoResposta.aguardando;

    return GestureDetector(
      onTap: tocavel ? () => _responder(alt.texto) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16 * scale,
          vertical: 14 * scale,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
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
// _ResultadoScreen — tela final com placar
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

  static const Color bgTop = Color(0xFF130A24);
  static const Color bgBottom = Color(0xFF1F1035);
  static const Color cardColor = Color(0xFF2A1B47);
  static const Color roxo = Color(0xFF7C5CFF);
  static const Color roxoClaro = Color(0xFFB9A6FF);
  static const Color verde = Color(0xFF4ADE80);
  static const Color vermelho = Color(0xFFF87171);
  static const Color amarelo = Color(0xFFFBBF24);

  Color get _corResultado {
    final pct = acertos / total;
    if (pct >= 0.8) return verde;
    if (pct >= 0.5) return amarelo;
    return vermelho;
  }

  String get _mensagem {
    final pct = acertos / total;
    if (pct == 1.0) return '🏆 Perfeito! Você zerou!';
    if (pct >= 0.8) return '🎉 Muito bem!';
    if (pct >= 0.5) return '👍 Bom esforço!';
    return '📚 Continue praticando!';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 390).clamp(0.9, 1.25);
    final double heightScale = (size.height / 844).clamp(0.85, 1.35);
    final cor = _corResultado;

    return Scaffold(
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
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Badge do mundo
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14 * scale,
                      vertical: 6 * scale,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: roxo.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Mundo ${nomeMundo[0].toUpperCase()}${nomeMundo.substring(1)}',
                      style: TextStyle(
                        color: roxoClaro,
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * scale,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32 * heightScale),

                // Placar circular
                Center(
                  child: Container(
                    width: 130 * scale,
                    height: 130 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cor.withOpacity(0.12),
                      border: Border.all(color: cor, width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$acertos/$total',
                          style: GoogleFonts.alfaSlabOne(
                            color: cor,
                            fontSize: 36 * scale,
                          ),
                        ),
                        Text(
                          'acertos',
                          style: TextStyle(
                            color: cor.withOpacity(0.8),
                            fontSize: 13 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28 * heightScale),

                // Mensagem
                Text(
                  _mensagem,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24 * scale,
                  ),
                ),
                SizedBox(height: 10 * heightScale),

                // Detalhes
                Container(
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('✅ Corretas', '$acertos', verde, scale),
                      Container(width: 1, height: 40, color: Colors.white12),
                      _buildStat(
                        '❌ Erradas',
                        '${total - acertos}',
                        vermelho,
                        scale,
                      ),
                      Container(width: 1, height: 40, color: Colors.white12),
                      _buildStat('📊 Total', '$total', roxoClaro, scale),
                    ],
                  ),
                ),
                SizedBox(height: 36 * heightScale),

                // Botão voltar ao mapa
                SizedBox(
                  height: 56 * scale,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roxo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Voltar ao Mapa 🗺️',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * scale,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String valor, Color cor, double scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valor,
          style: TextStyle(
            color: cor,
            fontWeight: FontWeight.bold,
            fontSize: 22 * scale,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 11 * scale),
        ),
      ],
    );
  }
}
