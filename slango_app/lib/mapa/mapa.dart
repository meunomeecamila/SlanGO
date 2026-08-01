import 'package:flutter/material.dart';

import '../missao/widgets/missao.dart';
import 'data/mundos_mock.dart';
import 'widgets/tela_mapa.dart';

/// Tela do mapa de mundos: monta a TelaMapa com a lista de mundos
/// e trata a navegação para a missão do mundo selecionado.
class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TelaMapa(
      mundos: mundos,
      onExplorar: (mundo) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Missao(nomeMundo: mundo.id)),
        );
      },
    );
  }
}
