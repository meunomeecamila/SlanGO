import 'package:flutter/material.dart';

import '../shared/widgets/background_espaco.dart';
import '../perfil/perfil_screen.dart';
import '../shared/widgets/fundo_espacial.dart';
import 'widgets/botoes_inicio.dart';
import 'widgets/logo_slango.dart';
import 'widgets/texto_boas_vindas.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundEspaco(child: SizedBox.expand()),
          ),
          const Positioned.fill(child: FundoEspacial(interativo: false)),
          SafeArea(
          child: Stack(
            children: [
              // Mundo Jogos
              Positioned(
                left: -50,
                top: 0,
                child: Image.asset(
                  "images/mundo.png",
                  width: 200,
                ),
              ),

              // Mundo K-Pop
              Positioned(
                right: 0,
                top: -20,
                child: Image.asset(
                  "images/kpop.png",
                  width: 150,
                ),
              ),

              // Mundo Esportes
              Positioned(
                right: -20,
                top: 180,
                child: Image.asset(
                  "images/esportes.png",
                  width: 120,
                ),
              ),

              // Mundo Maquiagem
              Positioned(
                right: 240,
                bottom: 40,
                child: Image.asset(
                  "images/maquiagem.png",
                  width: 250,
                ),
              ),

              // Mundo Geek
              Positioned(
                left: 300,
                bottom: 40,
                child: Image.asset(
                  "images/geek.png",
                  width: 140,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),

                        const LogoSlango(),

                        const SizedBox(height: 30),

                        const TextoBoasVindas(),

                        const SizedBox(height: 50),

                        const BotoesInicio(),
                      ],
                    ),
                  ),
                ),
              ),

              // Ícone de perfil, sempre visível por cima do resto do conteúdo
              Positioned(
                top: 8,
                right: 16,
                child: _IconePerfil(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PerfilScreen(
                          nome: "Mariana",
                          avatarAsset: "images/avatar_astronauta.png",
                          totalMundos: 3,
                          totalGirias: 15,
                          totalCertificados: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}

class _IconePerfil extends StatelessWidget {
  final VoidCallback onTap;

  const _IconePerfil({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}