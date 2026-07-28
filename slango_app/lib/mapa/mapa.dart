import 'package:flutter/material.dart';

import 'data/mundos_mock.dart';
import 'models/mundo.dart';
import 'widgets/background_espaco.dart';
import 'widgets/card_mundo.dart';
import 'widgets/mapa_header.dart';
import 'widgets/navegacao_mundos.dart';
import 'widgets/planeta_widget.dart';

import '../missao/missao.dart';


class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}


class _MapaScreenState extends State<MapaScreen> {
  int mundoAtual = 0;

  Mundo get mundo => mundos[mundoAtual];


  void proximoMundo() {
    if (mundoAtual < mundos.length - 1) {
      setState(() {
        mundoAtual++;
      });
    }
  }


  void mundoAnterior() {
    if (mundoAtual > 0) {
      setState(() {
        mundoAtual--;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundEspaco(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const MapaHeader(),

                const SizedBox(height: 10),


                Expanded(
                  child: Center(
                    child: PlanetaWidget(
                      mundo: mundo,
                    ),
                  ),
                ),


                NavegacaoMundos(
                  paginaAtual: mundoAtual,
                  totalPaginas: mundos.length,
                  onAnterior: mundoAnterior,
                  onProximo: proximoMundo,
                ),


                const SizedBox(height: 30),


                CardMundo(
                  mundo: mundo,

                  onExplorar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Missao(),
                      ),
                    );
                  },
                ),


                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}