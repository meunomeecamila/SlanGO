import 'package:flutter/material.dart';

import '../shared/widgets/background_espaco.dart';

import 'widgets/app_bar_missao.dart';
import 'widgets/alien.dart';
import 'widgets/balao_fala.dart';
import 'widgets/lista_girias.dart';
import 'widgets/botao_missao.dart';


class Missao extends StatelessWidget {
  const Missao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: BackgroundEspaco(
        child: SafeArea(
          child: Column(
            children: [

              // Barra superior
              const AppBarMissao(
                nomeMundo: "Mundo Gamer",
              ),

              const SizedBox(height: 30),


              // Conteúdo principal
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),

                  child: Column(
                    children: [

                      // Alien
const Alien(
  imagem: "assets/images/alien.png",
),

const SizedBox(height: 25),

// Fala do alien
const BalaoFala(
  texto:
      "Olá, terráqueo! 👽\n"
      "Hoje vamos aprender algumas gírias da internet!",
),


                      const SizedBox(height: 25),


                      // Lista de gírias
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Novas palavras encontradas:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ListaGirias(
                        girias: [
                          "cringe",
                          "shippar",
                          "flopar",
                          "stalkear",
                        ],
                      ),


                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              ),


              // Botão inferior
              Padding(
                padding: const EdgeInsets.all(24),
                child: BotaoMissao(
                  texto: "Começar missão 🚀",
                  onPressed: () {

                    // Próximo passo:
                    // navegar para a primeira atividade

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}