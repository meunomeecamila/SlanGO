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
                
                Positioned(
                  left: -50,
                  top: 0,
                  child: Image.asset("images/mundo.png", width: 200),
                ),

                
                Positioned(
                  right: 0,
                  top: -20,
                  child: Image.asset("images/kpop.png", width: 150),
                ),

                
                Positioned(
                  right: -20,
                  top: 180,
                  child: Image.asset("images/esportes.png", width: 120),
                ),

                
                Positioned(
                  right: 240,
                  bottom: 40,
                  child: Image.asset("images/maquiagem.png", width: 250),
                ),

                
                Positioned(
                  left: 300,
                  bottom: 40,
                  child: Image.asset("images/geek.png", width: 140),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
