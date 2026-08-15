/// Status possíveis de uma sugestão de gíria. Espelha o `varchar` na tabela
/// `sugestoes_girias` do Supabase.
enum StatusSugestao { pendente, aprovado, rejeitado }

extension StatusSugestaoX on StatusSugestao {
  String get valorBackend {
    switch (this) {
      case StatusSugestao.pendente:
        return 'PENDENTE';
      case StatusSugestao.aprovado:
        return 'APROVADO';
      case StatusSugestao.rejeitado:
        return 'REJEITADO';
    }
  }

  String get rotulo {
    switch (this) {
      case StatusSugestao.pendente:
        return 'Em Análise';
      case StatusSugestao.aprovado:
        return 'Aprovado';
      case StatusSugestao.rejeitado:
        return 'Recusado';
    }
  }

  static StatusSugestao fromString(String? raw) {
    switch ((raw ?? '').trim().toUpperCase()) {
      case 'APROVADO':
        return StatusSugestao.aprovado;
      case 'REJEITADO':
        return StatusSugestao.rejeitado;
      case 'PENDENTE':
      default:
        return StatusSugestao.pendente;
    }
  }
}

/// Modelo local espelhando os campos da tabela `sugestoes_girias`.
class SugestaoGiria {
  final String id;
  final int usuarioId;
  final String nome;
  final String significado;
  final String exemplo;
  final String impacto;
  final String impactoMotivo;
  final String classeGramatical;
  final StatusSugestao status;
  final DateTime? criadoEm;
  final String? descricaoAdm;
  final String? quemAceitou;
  final String? proponenteNome;

  const SugestaoGiria({
    required this.id,
    required this.usuarioId,
    required this.nome,
    required this.significado,
    required this.exemplo,
    required this.impacto,
    required this.impactoMotivo,
    required this.classeGramatical,
    required this.status,
    this.criadoEm,
    this.descricaoAdm,
    this.quemAceitou,
    this.proponenteNome,
  });

  bool get foiAvaliada => status != StatusSugestao.pendente;

  factory SugestaoGiria.fromJson(Map<String, dynamic> json) {
    return SugestaoGiria(
      id: json['id'].toString(),
      usuarioId: (json['usuario_id'] as num?)?.toInt() ?? 0,
      nome: (json['nome'] ?? '').toString(),
      significado: (json['significado'] ?? '').toString(),
      exemplo: (json['exemplo'] ?? '').toString(),
      impacto: (json['impacto'] ?? '').toString(),
      impactoMotivo: (json['impacto_motivo'] ?? '').toString(),
      classeGramatical: (json['classe_gramatical'] ?? '').toString(),
      status: StatusSugestaoX.fromString(json['status'] as String?),
      criadoEm: json['criado_em'] != null
          ? DateTime.tryParse(json['criado_em'].toString())
          : null,
      descricaoAdm: json['descricao_adm']?.toString(),
      quemAceitou: json['quem_aceitou']?.toString(),
      proponenteNome: json['proponente_nome']?.toString(),
    );
  }
}
