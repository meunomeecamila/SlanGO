// Falas embutidas no código (fonte de verdade offline).
///
/// O `FalasService` tenta primeiro ler `assets/json/falas.json`; se o asset
/// não estiver no bundle (é preciso *restart* completo, hot reload não
/// re-empacota assets) ou o mundo não existir lá, usamos este mapa.
///
/// Cada mundo aponta para um mapa de locale ('pt', 'en', 'es') -> falas.
const Map<String, Map<String, List<String>>> falasPorMundo = {
  'jogos': {
    'pt': [
      'Olá, {nome}! Bem-vindo ao Mundo dos Games! 🎮',
      'Aqui os jogadores falam uma língua própria: MVP, clutch, feed, noob...',
      'Fica esperto nas gírias abaixo e depois é só iniciar a missão! 🚀',
    ],
    'en': [
      'Hey, {nome}! Welcome to the Gaming World! 🎮',
      'Here gamers speak a language of their own: MVP, clutch, feed, noob...',
      "Check out the slang below, then it's time to start the mission! 🚀",
    ],
    'es': [
      '¡Hola, {nome}! ¡Bienvenido al Mundo de los Juegos! 🎮',
      'Aquí los gamers hablan un idioma propio: MVP, clutch, feed, noob...',
      '¡Échale un vistazo a la jerga de abajo y luego solo queda iniciar la misión! 🚀',
    ],
  },
  'kpop': {
    'pt': [
      'Annyeong {nome}! Você chegou ao planeta do K-Pop! 🎤',
      'Aqui tem bias, comeback, fanchant e muito mais.',
      'Decora essas gírias e arrasa na missão, stan! 💜',
    ],
    'en': [
      "Annyeong {nome}! You've reached the K-Pop planet! 🎤",
      "Here you'll find bias, comeback, fanchant, and much more.",
      'Memorize this slang and crush the mission, stan! 💜',
    ],
    'es': [
      '¡Annyeong {nome}! ¡Llegaste al planeta del K-Pop! 🎤',
      'Aquí hay bias, comeback, fanchant y mucho más.',
      '¡Apréndete esta jerga y arrasa en la misión, stan! 💜',
    ],
  },
  'maquiagem': {
    'pt': [
      'Bem-vindo, {nome}! Você chegou ao planeta da beleza! 💄',
      'Por aqui se fala em blush, contorno, glow e pele de vidro.',
      'Dá uma olhada nas gírias e depois é só brilhar na missão! ✨',
    ],
    'en': [
      "Welcome, {nome}! You've reached the beauty planet! 💄",
      'Here people talk about blush, contouring, glow, and glass skin.',
      "Take a look at the slang, then it's time to shine in the mission! ✨",
    ],
    'es': [
      '¡Bienvenido, {nome}! ¡Llegaste al planeta de la belleza! 💄',
      'Aquí se habla de blush, contorno, glow y piel de cristal.',
      '¡Échale un vistazo a la jerga y luego solo queda brillar en la misión! ✨',
    ],
  },
  'pop': {
    'pt': [
      'Chegamos ao planeta da cultura pop, {nome}! 🌎',
      'Filmes, séries, memes e celebridades têm um vocabulário próprio.',
      'Estuda as gírias abaixo e bora pra missão! 🍿',
    ],
    'en': [
      "We've landed on the pop culture planet, {nome}! 🌎",
      'Movies, shows, memes, and celebrities have their own vocabulary.',
      "Study the slang below and let's get to the mission! 🍿",
    ],
    'es': [
      '¡Llegamos al planeta de la cultura pop, {nome}! 🌎',
      'Películas, series, memes y celebridades tienen un vocabulario propio.',
      '¡Estudia la jerga de abajo y vamos a la misión! 🍿',
    ],
  },
  'antigo': {
    'pt': [
      'Segura essa, {nome}: bem-vindo ao Mundo Antigo! 📼',
      'Aqui rolam gírias que seus pais usavam e ainda dão o maior barato.',
      'Dá uma treinada nelas antes de encarar a missão! 🕰️',
    ],
    'en': [
      'Hold on to your hat, {nome}: welcome to the Retro World! 📼',
      "Here's the slang your parents used and still get a kick out of.",
      'Get some practice in before you take on the mission! 🕰️',
    ],
    'es': [
      'Agárrate, {nome}: ¡bienvenido al Mundo Antiguo! 📼',
      'Aquí circula la jerga que usaban tus padres y todavía les encanta.',
      '¡Practícala un poco antes de encarar la misión! 🕰️',
    ],
  },
  'cotidiano': {
    'pt': [
      'E aí, {nome}, tudo certo? Bem-vindo ao Mundo Cotidiano! ☕',
      'São aquelas gírias do dia a dia que a gente solta sem nem pensar.',
      'Confere a lista e parte pra missão! 🚀',
    ],
    'en': [
      "Hey {nome}, how's it going? Welcome to the Everyday World! ☕",
      'These are the everyday slang words we drop without even thinking.',
      'Check out the list and head off to the mission! 🚀',
    ],
    'es': [
      '¿Qué tal, {nome}, todo bien? ¡Bienvenido al Mundo Cotidiano! ☕',
      'Son esas jergas del día a día que soltamos sin pensar.',
      '¡Revisa la lista y vamos a la misión! 🚀',
    ],
  },
  'esportes': {
    'pt': [
      'Bola rolando, {nome}! Você entrou no Mundo Esportes! ⚽',
      'Aqui é chapéu, pendurar as chuteiras, gol de placa e muito mais.',
      'Aquece com as gírias abaixo e entra em campo na missão! 🏆',
    ],
    'en': [
      "Kickoff, {nome}! You've entered the Sports World! ⚽",
      "Here it's nutmegs, hanging up the boots, screamers, and much more.",
      'Warm up with the slang below and step onto the field for the mission! 🏆',
    ],
    'es': [
      '¡Rueda el balón, {nome}! ¡Entraste al Mundo Deportes! ⚽',
      'Aquí es caño, colgar los botines, golazo y mucho más.',
      '¡Calienta con la jerga de abajo y entra a la cancha en la misión! 🏆',
    ],
  },
  'geek': {
    'pt': [
      'Saudações, {nome}! Bem-vindo ao Mundo Geek! 🛸',
      'Animes, HQs, RPG e tecnologia têm um dialeto próprio.',
      'Estuda o grimório de gírias e parte pra missão! 🧙',
    ],
    'en': [
      'Greetings, {nome}! Welcome to the Geek World! 🛸',
      'Anime, comics, RPGs, and tech have their own dialect.',
      'Study the slang grimoire and head off to the mission! 🧙',
    ],
    'es': [
      '¡Saludos, {nome}! ¡Bienvenido al Mundo Geek! 🛸',
      'Animes, cómics, RPG y tecnología tienen su propio dialecto.',
      '¡Estudia el grimorio de jerga y vamos a la misión! 🧙',
    ],
  },
  'redessociais': {
    'pt': [
      'Bem-vindo ao planeta das timelines, {nome}! 📱',
      'Aqui se fala em mutual, crush, trend, POV e shippar.',
      'Dá scroll nas gírias abaixo e começa a missão! 💬',
    ],
    'en': [
      'Welcome to the timelines planet, {nome}! 📱',
      'Here people talk about mutuals, crushes, trends, POV, and shipping.',
      'Scroll through the slang below and start the mission! 💬',
    ],
    'es': [
      '¡Bienvenido al planeta de las timelines, {nome}! 📱',
      'Aquí se habla de mutual, crush, trend, POV y shippear.',
      '¡Haz scroll en la jerga de abajo y comienza la misión! 💬',
    ],
  },
  'relacionamentos': {
    'pt': [
      'Chegou no planeta dos corações, {nome}! 💜',
      'Rolo, ficante, mozão, red flag... tem gíria pra tudo por aqui.',
      'Aprende essas expressões e vai com tudo pra missão! 💘',
    ],
    'en': [
      "You've reached the planet of hearts, {nome}! 💜",
      "Fling, hookup, bae, red flag... there's slang for everything here.",
      'Learn these expressions and go all in on the mission! 💘',
    ],
    'es': [
      '¡Llegaste al planeta de los corazones, {nome}! 💜',
      'Rollo, ligue, amor, red flag... aquí hay jerga para todo.',
      '¡Aprende estas expresiones y ve con todo a la misión! 💘',
    ],
  },
  // Mundo Comunidade — feito pela galera. Ainda sem gírias cadastradas,
  // por isso as falas focam em colaboração/comunidade em vez de listar gírias.
  'comunidade': {
    'pt': [
      'Boas-vindas ao Mundo Comunidade, {nome}! Aqui é onde a voz da galera ganha vida! 🌍',
      'Este mundo é construído por vocês! Que tal mandar sua própria gíria? ✍️',
      'Ainda estamos reunindo as gírias mais faladas da galáxia... Fique de olho! 👀',
      'Conectando mentes e gírias de todos os cantos do universo! 🚀',
    ],
    'en': [
      "Welcome to the Community World, {nome}! This is where everyone's voice comes to life! 🌍",
      'This world is built by you! How about submitting your own slang? ✍️',
      "We're still gathering the most talked-about slang in the galaxy... Stay tuned! 👀",
      'Connecting minds and slang from every corner of the universe! 🚀',
    ],
    'es': [
      '¡Bienvenido al Mundo Comunidad, {nome}! ¡Aquí es donde la voz de todos cobra vida! 🌍',
      '¡Este mundo lo construyen ustedes! ¿Qué tal enviar tu propia jerga? ✍️',
      'Todavía estamos reuniendo la jerga más hablada de la galaxia... ¡Mantente atento! 👀',
      '¡Conectando mentes y jergas de todos los rincones del universo! 🚀',
    ],
  },
};