class Alternativa {
  final String texto;
  final bool correta;

  const Alternativa({
    required this.texto,
    required this.correta,
  });

  factory Alternativa.fromJson(Map<String, dynamic> json) {
    return Alternativa(
      texto: json['texto'] as String,
      correta: json['correta'] as bool,
    );
  }
}

class Fase {
  final int id;
  final dynamic giriaId; 
  final String giria;
  final List<String> variacoes;
  final String pergunta;
  final String explicacao;
  final String exemplo;
  final String? classe;
  final String respostaCorreta;
  final List<Alternativa> alternativas;

  const Fase({
    required this.id,
    required this.giriaId, 
    required this.giria,
    required this.variacoes,
    required this.pergunta,
    required this.explicacao,
    required this.exemplo,
    this.classe,
    required this.respostaCorreta,
    required this.alternativas,
  });

  factory Fase.fromJson(Map<String, dynamic> json) {
    return Fase(
      id: json['id'] as int,
      giriaId: json['giriaId'], 
      giria: json['giria'] as String,
      variacoes: (json['variacoes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pergunta: json['pergunta'] as String,
      explicacao: json['explicacao'] as String,
      exemplo: json['exemplo'] as String,
      classe: json['classe'] as String?,
      respostaCorreta: json['respostaCorreta'] as String,
      alternativas: (json['alternativas'] as List<dynamic>)
          .map((e) => Alternativa.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RodadaMundo {
  final String id;
  final String nome;
  final String descricao;
  final List<Fase> fases;
  final List<Fase> todasAsPerguntas;

  const RodadaMundo({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.fases,
    required this.todasAsPerguntas,
  });

  factory RodadaMundo.fromJson(Map<String, dynamic> json) {
    return RodadaMundo(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      fases: (json['fases'] as List<dynamic>)
          .map((e) => Fase.fromJson(e as Map<String, dynamic>))
          .toList(),
      todasAsPerguntas: (json['todasAsPerguntas'] as List<dynamic>)
          .map((e) => Fase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}