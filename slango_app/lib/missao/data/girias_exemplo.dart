import 'mundo_slug.dart';

/// Gírias de exemplo (4 por mundo) exibidas em forma de chips na tela de
/// missão e reaproveitadas na mensagem do certificado.
///
/// TODO: Estas gírias são ESTÁTICAS (apenas exemplos de vitrine). Para trocar
/// as gírias mostradas de um mundo, edite a lista do slug correspondente
/// abaixo. Os dados completos vivem em `girias/<slug>.json`.
const Map<String, List<String>> giriasExemploPorMundo = {
  'jogos': ['TROLL', 'TILT', 'RUSH', 'FARM'],
  'kpop': ['BIAS', 'MAKNAE', 'COMEBACK', 'STAN'],
  'pop': ['LACRAR', 'SLAY', 'FLOPAR', 'DELULU'],
  'maquiagem': ['ESFUMADO', 'PELE DE VIDRO', 'POSTIÇO', 'GLOW UP'],
  'antigo': ['BAFAFÁ', 'BARBEIRO', 'CHÁ DE CADEIRA', 'BOA PINTA'],
  'cotidiano': ['CRINGE', 'RIZZ', 'SIGMA', 'BISCOITAR'],
  'esportes': ['FIRULA', 'MÃO DE ALFACE', 'DE LAVADA', 'MIGUEZENTO'],
  'geek': ['OTAKU', 'WAIFU', 'FILLER', 'COSPLAY'],
  'redessociais': ['RANÇO', 'BISCOITEIRO', 'STALKEAR', 'TÁ NA DISNEY'],
  'relacionamentos': ['CRUSH', 'CONTATINHO', 'LEVAR BOLO', 'TALARICO'],
  // Mundo Comunidade ainda não tem gírias (lista vazia => nenhum chip é exibido).
  'comunidade': <String>[],
};

/// Fallback quando o mundo não estiver mapeado acima.
const List<String> giriasExemploPadrao = ['GÍRIA', 'SLANG', 'EXEMPLO', 'NOVO'];

/// Devolve as 4 gírias de exemplo do mundo a partir de qualquer variação do
/// nome ("K-Pop", "Mundo K-Pop", "kpop"...).
List<String> giriasExemploDoMundo(String nomeMundo) {
  final slug = normalizarMundo(nomeMundo);
  return giriasExemploPorMundo[slug] ?? giriasExemploPadrao;
}
