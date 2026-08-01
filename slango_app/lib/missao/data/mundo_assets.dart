import 'mundo_slug.dart';

/// Imagem do ET (pet) de cada mundo, indexada pelo slug canônico.
const Map<String, String> imagensDosEts = {
  'jogos': 'images/planets_pets/jogo_pet.png',
  'kpop': 'images/planets_pets/kpop_pet.png',
  'maquiagem': 'images/planets_pets/maquiagem_pet.png',
  'pop': 'images/planets_pets/pop_pet.png',
  'antigo': 'images/planets_pets/antigo_pet.png',
  'cotidiano': 'images/planets_pets/cotidiano_pet.png',
  'esportes': 'images/planets_pets/esporte_pet.png',
  'geek': 'images/planets_pets/geek_pet.png',
  'redessociais': 'images/planets_pets/redessociais_pet.png',
  'relacionamentos': 'images/planets_pets/relacionamentos_pet.png',
};

/// Devolve o caminho do ET do mundo a partir de qualquer variação do nome
/// ("K-Pop", "Mundo K-Pop", "kpop"...). Cai no avatar genérico se não achar.
String petDoMundo(String nomeMundo) {
  final slug = normalizarMundo(nomeMundo);
  return imagensDosEts[slug] ?? 'images/avatar.png';
}