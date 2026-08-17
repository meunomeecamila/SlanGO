import 'package:flutter/material.dart';

import 'cores.dart';
import 'texto.dart';
import '../final/Particulas.dart';
import 'models.dart';

/// ⚠️ Se você já tiver uma cor roxa definida em cores.dart
/// (ex: AppColors.roxo, AppColors.primary, AppColors.accent),
/// troque as referências a `_roxoAccent` abaixo por ela.
const Color _roxoAccent = Color(0xFF8B7CF6);
const Color _roxoGlow = Color(0xFF6C5CE7);

/// Modelo simples pra representar uma gíria dentro de um mundo.
/// Se você já tiver algo parecido em models.dart, troque por ele.
class GiriaProgresso {
  final String palavra;
  final String significado;
  final bool aprendida;
  final String? exemplo;
  final String classe; // classe gramatical (substantivo, verbo, etc)

  const GiriaProgresso({
    required this.palavra,
    required this.significado,
    required this.aprendida,
    this.exemplo,
    this.classe = "gíria",
  });
}

/// Lista estática de exemplo — troque/pluga na sua fonte de dados real depois.
/// Só as 2 primeiras estão marcadas como aprendidas; o resto fica "trancado".
const List<GiriaProgresso> giriasExemplo = [
  GiriaProgresso(
    palavra: "Salty",
    significado: "Estar irritado, chateado ou ressentido com algo pequeno.",
    exemplo: "Ele ficou salty depois de perder a partida.",
    classe: "adjetivo",
    aprendida: true,
  ),
  GiriaProgresso(
    palavra: "Ghosting",
    significado: "Sumir de uma conversa ou relacionamento sem explicação.",
    exemplo: "Ela deu ghosting nele depois do primeiro encontro.",
    classe: "substantivo",
    aprendida: true,
  ),
  GiriaProgresso(
    palavra: "Flex",
    significado: "Ostentar ou se gabar de algo, geralmente uma conquista ou posse.",
    exemplo: "Ele tá dando flex com o carro novo.",
    classe: "verbo",
    aprendida: false,
  ),
  GiriaProgresso(
    palavra: "Sus",
    significado: "Abreviação de 'suspicious' — algo ou alguém suspeito.",
    exemplo: "Esse comportamento dele tá meio sus.",
    classe: "adjetivo",
    aprendida: false,
  ),
  GiriaProgresso(
    palavra: "Cap",
    significado: "Mentira. 'No cap' significa 'sem mentira, sério mesmo'.",
    exemplo: "Isso que você falou é cap, no cap.",
    classe: "substantivo",
    aprendida: false,
  ),
  GiriaProgresso(
    palavra: "Vibe check",
    significado: "Avaliar rapidamente o clima ou energia de uma situação ou pessoa.",
    exemplo: "Chegou na festa e já fez um vibe check.",
    classe: "expressão",
    aprendida: false,
  ),
];

class GiriasMundoScreen extends StatelessWidget {
  final ProgressoMundo mundo;
  final List<GiriaProgresso> girias;

  /// Se `girias` não for passado (ou vier nulo), cai automaticamente
  /// na lista estática `giriasExemplo` — assim a tela nunca aparece vazia
  /// enquanto você não pluga a fonte de dados real.
  GiriasMundoScreen({
    super.key,
    required this.mundo,
    List<GiriaProgresso>? girias,
  }) : girias = girias ?? giriasExemplo;

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: girias.isEmpty
                      ? Center(
                          child: Text(
                            "Nenhuma gíria cadastrada ainda.",
                            style: AppText.subtitulo(1),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 16,
                              runSpacing: 16,
                              children: girias
                                  .map((g) => _cardGiria(context, g))
                                  .toList(),
                            ),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mundo.nome, style: AppText.titulo(0.85)),
              const SizedBox(height: 2),
              Text(
                "${mundo.girasAprendidas}/${mundo.totalGirias} gírias aprendidas",
                style: AppText.subtitulo(0.9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardGiria(BuildContext context, GiriaProgresso giria) {
    final bool aprendida = giria.aprendida;

    return Opacity(
      opacity: aprendida ? 1.0 : 0.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        // Só permite o toque (e abrir o significado) se a gíria já foi aprendida.
        onTap: aprendida ? () => _mostrarSignificado(context, giria) : null,
        child: Container(
          width: 138,
          height: 92,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: aprendida ? _roxoAccent : AppColors.disabled,
              width: aprendida ? 1.8 : 1,
            ),
            boxShadow: aprendida
                ? [
                    BoxShadow(
                      color: _roxoGlow.withOpacity(0.55),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: _roxoGlow.withOpacity(0.25),
                      blurRadius: 30,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Text(
            giria.palavra,
            textAlign: TextAlign.center,
            style: AppText.cardTitulo(0.9).copyWith(
              color: aprendida ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarSignificado(BuildContext context, GiriaProgresso giria) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _roxoAccent, width: 1.6),
              boxShadow: [
                BoxShadow(
                  color: _roxoGlow.withOpacity(0.5),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Topo: rótulo + botão fechar
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "IDENTIFIQUE O SIGNIFICADO",
                        style: AppText.subtitulo(0.72).copyWith(
                          color: _roxoAccent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Palavra em destaque com glow roxo
                Text(
                  giria.palavra.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppText.titulo(1.6).copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: _roxoGlow.withOpacity(0.8), blurRadius: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  giria.classe,
                  style: AppText.subtitulo(0.85).copyWith(color: _roxoAccent),
                ),
                const SizedBox(height: 18),

                // Ícone + significado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _roxoAccent, width: 1.4),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: _roxoAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppText.subtitulo(1).copyWith(color: AppColors.textPrimary),
                          children: [
                            TextSpan(
                              text: "Significado: ",
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: giria.significado),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Exemplo de uso (se houver)
                if (giria.exemplo != null) ...[
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Exemplo de uso:",
                          style: AppText.subtitulo(0.85).copyWith(
                            color: _roxoAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          giria.exemplo!,
                          style: AppText.subtitulo(0.95).copyWith(
                            color: AppColors.textPrimary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _roxoAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Entendi!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}