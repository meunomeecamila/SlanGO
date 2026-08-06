/// Modelo de Mundo (usado tanto para exibição no mapa quanto pelo
/// MundoService para consumir o backend).
///
/// Campo `id` adicionado: é o slug usado nas rotas do backend
/// (ex: "geek", "antigo") e usado por `Missao(nomeMundo: mundo.id)` e por
/// `MundoService`. Os campos de exibição (imagem, descricao, totalGirias,
/// progresso, desbloqueado) continuam existindo, com valores padrão, para
/// não quebrar CardMundo/PlanetaWidget quando o Mundo vier só com id/nome
/// (ex: resultado de GET /mundos, via Mundo.fromNomeCapitalizado).
class Mundo {
  final String id;
  final String nome;
  final String imagem;
  final String status;
  final String descricao;
  final int totalGirias;
  final int giriasAprendidas;
  final double progresso;
  final bool desbloqueado;

  const Mundo({
    required this.id,
    required this.nome,
    this.imagem = '',
    this.status = '',
    this.descricao = '',
    this.totalGirias = 0,
    this.giriasAprendidas = 0,
    this.progresso = 0.0,
    this.desbloqueado = false,
  });

  /// Deriva o [id] (slug) a partir do nome capitalizado retornado pelo
  /// backend em GET /mundos (ex: "Geek" -> "geek").
  factory Mundo.fromNomeCapitalizado(String nomeCapitalizado) {
    final id = nomeCapitalizado.isEmpty
        ? nomeCapitalizado
        : nomeCapitalizado[0].toLowerCase() + nomeCapitalizado.substring(1);

    return Mundo(id: id, nome: nomeCapitalizado);
  }
}
