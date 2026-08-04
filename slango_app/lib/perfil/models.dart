/// Item que aparece na aba "Itens" ou "Cores" do perfil.
class ItemPerfil {
  final String nome;
  final String iconAsset; // caminho de um ícone/imagem, ex: "images/icones/fone.png"
  final bool equipado;

  const ItemPerfil({
    required this.nome,
    required this.iconAsset,
    this.equipado = false,
  });
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