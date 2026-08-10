import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../mapa/styles/cores.dart';
import '../final/Particulas.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _nota = 0;
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _giriaController = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _comentarioController.dispose();
    _giriaController.dispose();
    super.dispose();
  }

  Future<void> _enviarFeedback() async {
    if (_nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Escolha uma nota antes de enviar"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _enviando = true);

    
    
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _enviando = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Obrigado pelo seu feedback!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Feedback",
          style: GoogleFonts.alfaSlabOne(
            color: AppColors.text,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: ParticulasFundo(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "Como está sendo sua experiência?",
                            style: GoogleFonts.poppins(
                              color: AppColors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Sua opinião nos ajuda a melhorar o SlanGO",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 28),

                          
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final estrelaAtiva = index < _nota;
                                return IconButton(
                                  onPressed: () {
                                    setState(() => _nota = index + 1);
                                  },
                                  icon: Icon(
                                    estrelaAtiva
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: estrelaAtiva
                                        ? AppColors.cyan
                                        : AppColors.textSecondary,
                                    size: 36,
                                  ),
                                );
                              }),
                            ),
                          ),

                          const SizedBox(height: 28),

                          
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.cyan,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Você conhece alguma gíria que não está nos nossos mundos? Nos conte aqui o nome e significado!",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _giriaController,
                              maxLines: 3,
                              style: const TextStyle(color: AppColors.text),
                              decoration: InputDecoration(
                                hintText:
                                    "Ex: \"bora\" - usada pra chamar alguém pra sair ou fazer algo...",
                                hintStyle: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.cyan,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Conte mais para a gente!",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _comentarioController,
                              maxLines: 5,
                              style: const TextStyle(color: AppColors.text),
                              decoration: InputDecoration(
                                hintText:
                                    "Escreva sua sugestão, elogio ou problema encontrado...",
                                hintStyle: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _enviando ? null : _enviarFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _enviando
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: AppColors.text,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      "Enviar feedback",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}