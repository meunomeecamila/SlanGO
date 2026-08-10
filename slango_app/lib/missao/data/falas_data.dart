// Falas embutidas no código (fonte de verdade offline).
///
/// O `FalasService` tenta primeiro ler `assets/json/falas.json`; se o asset
/// não estiver no bundle (é preciso *restart* completo, hot reload não
/// re-empacota assets) ou o mundo não existir lá, usamos este mapa.
const Map<String, List<String>> falasPorMundo = {
  'jogos': [
    'Olá, {nome}! Bem-vindo ao Mundo dos Games! 🎮',
    'Aqui os jogadores falam uma língua própria: MVP, clutch, feed, noob...',
    'Fica esperto nas gírias abaixo e depois é só iniciar a missão! 🚀'
  ],
  'kpop': [
    'Annyeong {nome}! Você chegou ao planeta do K-Pop! 🎤',
    'Aqui tem bias, comeback, fanchant e muito mais.',
    'Decora essas gírias e arrasa na missão, stan! 💜',
  ],
  'maquiagem': [
    'Bem-vindo, {nome}! Você chegou ao planeta da beleza! 💄',
    'Por aqui se fala em blush, contorno, glow e pele de vidro.',
    'Dá uma olhada nas gírias e depois é só brilhar na missão! ✨',
  ],
  'pop': [
    'Chegamos ao planeta da cultura pop, {nome}! 🌎',
    'Filmes, séries, memes e celebridades têm um vocabulário próprio.',
    'Estuda as gírias abaixo e bora pra missão! 🍿',
  ],
  'antigo': [
    'Segura essa, {nome}: bem-vindo ao Mundo Antigo! 📼',
    'Aqui rolam gírias que seus pais usavam e ainda dão o maior barato.',
    'Dá uma treinada nelas antes de encarar a missão! 🕰️',
  ],
  'cotidiano': [
    'E aí, {nome}, tudo certo? Bem-vindo ao Mundo Cotidiano! ☕',
    'São aquelas gírias do dia a dia que a gente solta sem nem pensar.',
    'Confere a lista e parte pra missão! 🚀',
  ],
  'esportes': [
    'Bola rolando, {nome}! Você entrou no Mundo Esportes! ⚽',
    'Aqui é chapéu, pendurar as chuteiras, gol de placa e muito mais.',
    'Aquece com as gírias abaixo e entra em campo na missão! 🏆',
  ],
  'geek': [
    'Saudações, {nome}! Bem-vindo ao Mundo Geek! 🛸',
    'Animes, HQs, RPG e tecnologia têm um dialeto próprio.',
    'Estuda o grimório de gírias e parte pra missão! 🧙',
  ],
  'redessociais': [
    'Bem-vindo ao planeta das timelines, {nome}! 📱',
    'Aqui se fala em mutual, crush, trend, POV e shippar.',
    'Dá scroll nas gírias abaixo e começa a missão! 💬',
  ],
  'relacionamentos': [
    'Chegou no planeta dos corações, {nome}! 💜',
    'Rolo, ficante, mozão, red flag... tem gíria pra tudo por aqui.',
    'Aprende essas expressões e vai com tudo pra missão! 💘',
  ],
};