import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../licao_page.dart';
import '../../shared/widgets/fundo_espacial.dart';
import '../data/falas_service.dart';
import '../data/mundo_assets.dart';
import '../data/girias_exemplo.dart';
import '../data/mundo_slug.dart';
import '../../service/usuarioService.dart';
import 'package:slango_app/mapa/mapa.dart';

// O campo de estrelas agora mora em shared/widgets/fundo_espacial.dart
// (com metade das partículas) e é reexportado para não quebrar imports antigos.
export '../../shared/widgets/fundo_espacial.dart' show FundoEspacial;

class TelaMundoDosJogos extends StatefulWidget {
  /// Slug do mundo (ex: 'jogos', 'geek') — vem do mapa.
  final String nomeMundo;

  const TelaMundoDosJogos({super.key, this.nomeMundo = 'jogos'});

  @override
  State<TelaMundoDosJogos> createState() => _TelaMundoDosJogosState();
}

class Missao extends TelaMundoDosJogos {
  const Missao({super.key, super.nomeMundo});
}

class _TelaMundoDosJogosState extends State<TelaMundoDosJogos> {
  /// Gírias de exemplo do mundo atual (4 por mundo, cada mundo com as suas).
  /// TODO: para alterar quais gírias aparecem nos chips, edite o mapa em
  /// lib/missao/data/girias_exemplo.dart.
  List<String> get giriasDoMundo => giriasExemploDoMundo(widget.nomeMundo);

  /// Slug canônico do mundo (ex: 'kpop'), derivado do nome recebido.
  String get _slugMundo => normalizarMundo(widget.nomeMundo);

  /// Título exibido no cabeçalho (ex: 'Mundo K-Pop').
  String get _tituloMundo => tituloDoMundo(widget.nomeMundo);

  // Falas carregadas via FalasService.
  // Para adicionar mais falas, insira novas strings neste arquivo aqui:
  // lib/missao/data/falas_data.dart (e, opcionalmente, assets/json/falas.json).
  List<String> _falasDoMundo = [];
  bool _carregandoFalas = true;

  // Índice da fala atual exibida no balão.
  int _indiceFala = 0;

  @override
  void initState() {
    super.initState();
    _carregarFalas();
  }

  Future<void> _carregarFalas() async {
    // Nome do usuário logado, pra personalizar falas com {nome} (ex: mundo
    // Jogos). Vem `null` em sessão de convidado ou se a busca falhar — nesse
    // caso o FalasService cai no tratamento genérico "astronauta".
    final nomeUsuario = await UsuarioService.obterNomeUsuarioOuNull();
    final falas = await FalasService.obterFalas(
      _slugMundo,
      nomeUsuario: nomeUsuario,
    );
    if (!mounted) return;
    setState(() {
      _falasDoMundo = falas;
      _indiceFala = 0;
      _carregandoFalas = false;
    });
  }

  /// Texto atual do balão (mensagem de carregamento enquanto busca as falas).
  String get _textoDaFala {
    if (_carregandoFalas) return 'Carregando transmissão...';
    if (_falasDoMundo.isEmpty) return '';
    return _falasDoMundo[_indiceFala];
  }

  bool get _temProximaFala =>
      !_carregandoFalas && _indiceFala < _falasDoMundo.length - 1;

  void _proximaFala() {
    if (!_temProximaFala) return;
    setState(() => _indiceFala++);
  }

  bool get _temFalaAnterior => !_carregandoFalas && _indiceFala > 0;

  void _falaAnterior() {
    if (!_temFalaAnterior) return;
    setState(() => _indiceFala--);
  }

  /// Asset do ET do mundo atual (centralizado em mundo_assets.dart).
  String get _imagemDoEt => petDoMundo(widget.nomeMundo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: GoogleFonts.poppins(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0F2E), Color(0xFF120B24), Color(0xFF0D0818)],
            ),
          ),
          child: Stack(
            children: [
              // Fundo de estrelas atrás de todo o conteúdo.
              const Positioned.fill(child: FundoEspacial()),
              SafeArea(
                child: Column(
                  children: [
                    CabecalhoComTituloCentralizado(nomeMundo: _tituloMundo),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // O balão contém APENAS o texto do ET.
                            // Tocar no balão avança para a próxima fala.
                            BalaoDeFala(
                              texto: _textoDaFala,
                              aoTocar: _temProximaFala ? _proximaFala : null,
                            ),

                            const SizedBox(height: 12),

                            // Navegação das falas — FORA do balão.
                            NavegacaoDasFalas(
                              mostrarVoltar: _temFalaAnterior,
                              aoVoltar: _falaAnterior,
                              mostrarContinuar: _temProximaFala,
                              aoContinuar: _proximaFala,
                              indiceAtual: _indiceFala,
                              total: _falasDoMundo.length,
                            ),

                            const SizedBox(height: 24),

                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MapaScreen(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 240,
                                      height: 240,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.purple.withOpacity(
                                              .45,
                                            ),
                                            blurRadius: 70,
                                            spreadRadius: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(_imagemDoEt, height: 210),
                                  ],
                                ),
                              ),
                            ),

                            ChipsDeGirias(girias: giriasDoMundo),
                            const SizedBox(height: 32),
                            BotaoIniciarMissao(
                              aoTocar: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LicaoPage(nomeMundo: widget.nomeMundo),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controles de navegação entre as falas do ET.
/// Fica fora do balão para não sofrer a estilização da caixa roxa.
class NavegacaoDasFalas extends StatelessWidget {
  final bool mostrarVoltar;
  final VoidCallback aoVoltar;
  final bool mostrarContinuar;
  final VoidCallback aoContinuar;
  final int indiceAtual;
  final int total;

  const NavegacaoDasFalas({
    super.key,
    required this.mostrarVoltar,
    required this.aoVoltar,
    required this.mostrarContinuar,
    required this.aoContinuar,
    required this.indiceAtual,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox(height: 4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (mostrarVoltar)
            BotaoVoltarFala(aoTocar: aoVoltar)
          else
            const SizedBox(width: 80),
          Text(
            '${indiceAtual + 1}/$total',
            style: const TextStyle(
              color: Color(0xFFB9A6E8),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (mostrarContinuar)
            BotaoContinuar(aoTocar: aoContinuar)
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}


class CabecalhoComTituloCentralizado extends StatelessWidget {
  final String nomeMundo;

  const CabecalhoComTituloCentralizado({super.key, required this.nomeMundo});

  static const Color purpleAccent = Color(0xFF6C4FC9);
  static const Color purpleLight = Color(0xFFB9A6E8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF241A3D),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: purpleAccent.withOpacity(0.7),
                  width: 1.5,
                ),
              ),
              child: Text(
                nomeMundo,
                style: const TextStyle(
                  color: purpleLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: BotaoEmFormatoDePilula(
              aoTocar: () => Navigator.of(context).maybePop(),
              conteudo: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Color(0xFFB9A6E8), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Mapa',
                    style: TextStyle(
                      color: Color(0xFFB9A6E8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
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
}

/// Balão de fala do ET: contém APENAS o texto da fala.
/// A navegação (Voltar/Continuar) fica fora, em [NavegacaoDasFalas].
class BalaoDeFala extends StatelessWidget {
  /// Fala atual do ET.
  final String texto;

  /// Tocar no balão avança para a próxima fala (null = não há próxima).
  final VoidCallback? aoTocar;

  const BalaoDeFala({super.key, required this.texto, this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: aoTocar,
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomPaint(
            painter: PintaPontaDoBalaoDeFala(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                color: const Color(0xFF241A3D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF6C4FC9), width: 1.5),
              ),
              child: Text(
                texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class BotaoContinuar extends StatelessWidget {
  final VoidCallback aoTocar;

  const BotaoContinuar({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: aoTocar,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C4FC9),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Continuar'),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 11),
        ],
      ),
    );
  }
}

/// Botão discreto para voltar à fala anterior do ET.
class BotaoVoltarFala extends StatelessWidget {
  final VoidCallback aoTocar;

  const BotaoVoltarFala({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: aoTocar,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFB9A6E8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 11),
          SizedBox(width: 4),
          Text('Voltar', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ChipsDeGirias extends StatelessWidget {
  final List<String> girias;

  const ChipsDeGirias({super.key, required this.girias});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: girias
            .map((giria) => ChipDeGiriaSemClique(texto: giria))
            .toList(),
      ),
    );
  }
}

class ChipDeGiriaSemClique extends StatelessWidget {
  final String texto;

  const ChipDeGiriaSemClique({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF241A3D),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF6C4FC9).withOpacity(0.7),
          width: 1.5,
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFFB9A6E8),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class BotaoIniciarMissao extends StatelessWidget {
  final VoidCallback aoTocar;

  const BotaoIniciarMissao({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: aoTocar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C5CE0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 6,
            shadowColor: const Color(0xFF7C5CE0).withOpacity(0.5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🚀', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'Iniciar Missão',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BotaoEmFormatoDePilula extends StatelessWidget {
  final Widget conteudo;
  final VoidCallback aoTocar;

  const BotaoEmFormatoDePilula({
    super.key,
    required this.conteudo,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF241A3D),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF6C4FC9).withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: conteudo,
      ),
    );
  }
}

class PintaPontaDoBalaoDeFala extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tintaDoBalao = Paint()
      ..color = const Color(0xFF6C4FC9)
      ..style = PaintingStyle.fill;

    final formaDaPonta = Path()
      ..moveTo(20, size.height)
      ..lineTo(36, size.height)
      ..lineTo(20, size.height + 16)
      ..close();

    canvas.drawPath(formaDaPonta, tintaDoBalao);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}