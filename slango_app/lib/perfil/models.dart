/// Item que aparece na aba "Itens" do perfil.
/// Agora vem do backend, com status de desbloqueio por progresso no mundo.
class ItemPerfil {
  final int id;
  final String nome;
  final String iconAsset; // URL da imagem (Cloudinary), vem do backend em url_item
  final bool desbloqueado;
  final bool equipado;

  const ItemPerfil({
    required this.id,
    required this.nome,
    required this.iconAsset,
    this.desbloqueado = false,
    this.equipado = false,
  });

  factory ItemPerfil.fromJson(Map<String, dynamic> json) {
    return ItemPerfil(
      id: json['id'] as int,
      nome: json['nome']?.toString() ?? '',
      iconAsset: json['url_item']?.toString() ?? '',
      desbloqueado: json['desbloqueado'] as bool? ?? false,
      equipado: json['equipado'] as bool? ?? false,
    );
  }

  ItemPerfil copyWith({bool? equipado}) {
    return ItemPerfil(
      id: id,
      nome: nome,
      iconAsset: iconAsset,
      desbloqueado: desbloqueado,
      equipado: equipado ?? this.equipado,
    );
  }
}

/// Astronauta (avatar) que o usuário pode escolher livremente,
/// sem nenhuma condição de desbloqueio.
class AstronautaPerfil {
  final int id;
  final String nome;
  final String urlAstronauta;

  const AstronautaPerfil({
    required this.id,
    required this.nome,
    required this.urlAstronauta,
  });

  factory AstronautaPerfil.fromJson(Map<String, dynamic> json) {
    return AstronautaPerfil(
      id: json['id'] as int,
      nome: json['nome']?.toString() ?? '',
      urlAstronauta: json['url_astronauta']?.toString() ?? '',
    );
  }
}

/// Certificado conquistado pelo usuário.
class CertificadoPerfil {
  final String nome;
  final String iconAsset;
  final DateTime dataConquista;

  const CertificadoPerfil({
    required this.nome,
    required this.iconAsset,
    required this.dataConquista,
  });
}

/// Progresso do usuário em um mundo específico (usado na tela de Progresso).
class ProgressoMundo {
  final String id;
  final String nome;
  final int girasAprendidas;
  final int totalGirias;

  const ProgressoMundo({
    required this.id,
    required this.nome,
    required this.girasAprendidas,
    required this.totalGirias,
  });

  double get progresso =>
      totalGirias == 0 ? 0 : girasAprendidas / totalGirias;
}