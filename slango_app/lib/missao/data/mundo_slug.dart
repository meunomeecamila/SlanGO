/// Utilitários de normalização de nome de mundo.
///
/// O nome do mundo pode chegar de várias formas ("K-Pop", "Mundo K-Pop",
/// "redes sociais", "Redes Sociais"). Aqui centralizamos a conversão para um
/// slug canônico (ex: "kpop", "redessociais") e para um título exibível
/// (ex: "Mundo K-Pop").
const Map<String, String> _acentos = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'ñ': 'n',
};

/// Converte qualquer variação para o slug canônico do mundo.
/// Ex: "Mundo K-Pop" -> "kpop"; "Redes Sociais" -> "redessociais".
String normalizarMundo(String nome) {
  var texto = nome.toLowerCase().trim();

  texto = texto.split('').map((c) => _acentos[c] ?? c).join();

  // remove o prefixo/palavra "mundo"
  texto = texto.replaceAll('mundo', '');

  // remove tudo que não for letra ou número (espaços, hífens, underscores...)
  texto = texto.replaceAll(RegExp(r'[^a-z0-9]'), '');

  return texto;
}

/// Títulos exibíveis por slug.
const Map<String, String> _titulosPorSlug = {
  'jogos': 'Mundo Jogos',
  'kpop': 'Mundo K-Pop',
  'maquiagem': 'Mundo Maquiagem',
  'pop': 'Mundo Pop',
  'antigo': 'Mundo Antigo',
  'cotidiano': 'Mundo Cotidiano',
  'esportes': 'Mundo Esportes',
  'geek': 'Mundo Geek',
  'redessociais': 'Mundo Redes Sociais',
  'relacionamentos': 'Mundo Relacionamentos',
};

/// Título amigável para o cabeçalho. Faz fallback capitalizando o nome cru.
String tituloDoMundo(String nome) {
  final slug = normalizarMundo(nome);
  final titulo = _titulosPorSlug[slug];
  if (titulo != null) return titulo;

  final bruto = nome.trim();
  if (bruto.isEmpty) return 'Mundo';
  final capitalizado = bruto[0].toUpperCase() + bruto.substring(1);
  return capitalizado.toLowerCase().contains('mundo')
      ? capitalizado
      : 'Mundo $capitalizado';
}