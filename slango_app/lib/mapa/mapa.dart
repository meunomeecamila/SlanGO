import 'package:flutter/material.dart';

import '../missao/widgets/missao.dart';
import '../service/MundoService.dart';
import '../mapa/models/mundo.dart';
import 'data/mundos_mock.dart';
import 'widgets/tela_mapa.dart';

/// Tela do mapa de mundos: monta a TelaMapa com a lista de mundos
/// e trata a navegação para a missão do mundo selecionado.
class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late Future<List<Mundo>> _mundosFut;

  @override
  void initState() {
    super.initState();
    _mundosFut = _carregarMundos();
  }

  Future<List<Mundo>> _carregarMundos() async {
    final progresso = await MundoService.obterProgressoMundos();

    return mundos.map((m) {
      final progressItem = progresso.firstWhere(
        (item) => item['id'] == m.id,
        orElse: () => <String, dynamic>{},
      );

      if (progressItem.isEmpty) return m;

      final totalGirias = progressItem['totalGirias'] as int? ?? m.totalGirias;
      final giriasAprendidas = progressItem['quantidadeAprendida'] as int? ?? 0;
      final progressoValor =
          (progressItem['progresso'] as num?)?.toDouble() ??
          (totalGirias > 0 ? giriasAprendidas / totalGirias : 0.0);

      return Mundo(
        id: m.id,
        nome: m.nome,
        imagem: m.imagem,
        status: m.status,
        descricao: m.descricao,
        totalGirias: totalGirias,
        giriasAprendidas: giriasAprendidas,
        progresso: progressoValor.clamp(0.0, 1.0),
        desbloqueado: m.desbloqueado,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Mundo>>(
      future: _mundosFut,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final mundosCarregados = snapshot.data ?? mundos;

        return TelaMapa(
          mundos: mundosCarregados,
          onExplorar: (mundo) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Missao(nomeMundo: mundo.id)),
            );
          },
        );
      },
    );
  }
}
