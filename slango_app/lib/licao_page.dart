import 'package:flutter/material.dart';

import 'fase/fase.dart';
import 'licao.dart';
import 'service/MundoService.dart';

class LicaoPage extends StatefulWidget {
  final String nomeMundo;

  const LicaoPage({super.key, required this.nomeMundo});

  @override
  State<LicaoPage> createState() => _LicaoPageState();
}

class _LicaoPageState extends State<LicaoPage> {
  late Future<List<Fase>> _futureFases;
  int _indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    _futureFases = MundoService.buscarFases(widget.nomeMundo);
  }

  void _avancar(List<Fase> fases) {
    if (_indiceAtual < fases.length - 1) {
      setState(() {
        _indiceAtual++;
      });
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/quiz',
        arguments: widget.nomeMundo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fase>>(
      future: _futureFases,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1F1035),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Erro ao carregar fases: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final fases = snapshot.data ?? [];

        if (fases.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1035),
            body: Center(
              child: Text(
                'Nenhuma fase encontrada.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final fase = fases[_indiceAtual];

        // SlangQuizScreen já é um Scaffold completo — não envolvemos em
        // outro Scaffold aqui.
        return SlangQuizScreen(
          palavra: fase.giria,
          classe: fase.classe ?? '',
          significado: fase.explicacao,
          exemplo: fase.exemplo,
          usageHighlight: fase.exemplo,
          progresso: (_indiceAtual + 1) / fases.length,
          onClose: () => Navigator.pop(context),
          onContinue: () => _avancar(fases),
        );
      },
    );
  }
}
