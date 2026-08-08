import 'package:flutter/material.dart';

import '../../missao/data/girias_exemplo.dart';
import '../../missao/data/mundo_assets.dart';
import '../../missao/data/mundo_slug.dart';

/// ============================================================
/// DADOS DOS CERTIFICADOS (um por mundo)
/// ============================================================
/// Este arquivo concentra TUDO que muda de um mundo para o outro dentro da
/// aba "Certificados" do perfil: cores temáticas, caminho do PDF estático e
/// a mensagem fofa do ETzinho.
///
/// TODO (TROCAR OS PDFs REAIS): o caminho do PDF oficial de cada mundo está
/// no campo `pdfAsset` do mapa `certificadosPorMundo` abaixo.
///   - Para usar OUTRO ARQUIVO LOCAL: coloque o arquivo em `assets/pdfs/` e
///     atualize a string (ex: 'assets/pdfs/certificado_jogos.pdf').
///     Lembre-se de manter a pasta `assets/pdfs/` declarada no pubspec.yaml.
///   - Para usar uma URL REMOTA: troque a string por uma URL https e ajuste
///     `CertificadoPdfService.baixarPdfOficialDoMundo` (há um TODO lá também).
class CertificadoMundo {
  /// Slug canônico do mundo (ex: 'jogos').
  final String slug;

  /// Nome exibido (ex: 'Mundo Jogos').
  final String nome;

  /// Cor principal do tema do mundo (usada quando desbloqueado).
  final Color corPrimaria;

  /// Cor secundária, para o gradiente do card.
  final Color corSecundaria;

  /// Caminho do PDF estático oficial deste mundo.
  /// TODO: troque aqui o caminho/URL do PDF real deste mundo.
  final String pdfAsset;

  /// Mensagem fofa do ETzinho, recheada com as gírias do planeta.
  final String mensagem;

  const CertificadoMundo({
    required this.slug,
    required this.nome,
    required this.corPrimaria,
    required this.corSecundaria,
    required this.pdfAsset,
    required this.mensagem,
  });

  /// Imagem estática do ETzinho/mascote do mundo.
  String get petAsset => petDoMundo(slug);

  /// Gírias de exemplo do mundo (mesma fonte usada na tela de missão).
  List<String> get girias => giriasExemploDoMundo(slug);

  /// Devolve uma cópia deste certificado com `{nome}` substituído pelo nome
  /// real do usuário logado (ou por "astronauta" se `nomeUsuario` vier nulo
  /// ou vazio — ex: convidado, ou ainda carregando).
  CertificadoMundo comNomeUsuario(String? nomeUsuario) {
    final nome = (nomeUsuario ?? '').trim();
    final tratamento = nome.isEmpty ? 'astronauta' : nome;
    return CertificadoMundo(
      slug: slug,
      nome: this.nome,
      corPrimaria: corPrimaria,
      corSecundaria: corSecundaria,
      pdfAsset: pdfAsset,
      mensagem: mensagem.replaceAll('{nome}', tratamento),
    );
  }
}

const Map<String, CertificadoMundo> certificadosPorMundo = {
  'jogos': CertificadoMundo(
    slug: 'jogos',
    nome: 'Mundo Jogos',
    corPrimaria: Color(0xFF7C5CFF),
    corSecundaria: Color(0xFF32E0C4),
    pdfAsset: 'assets/pdfs/certificado_jogos.pdf', // TODO: PDF real do mundo
    mensagem:
        'Aêêê, {nome}! Você deu RUSH em todas as gírias deste planeta e '
        'nem entrou em TILT uma vez. Nada de FARM sem sentido: você jogou '
        'limpo, sem TROLL, e platinou o Mundo Jogos. Obrigadinho por explorar '
        'cada cantinho comigo. GG! 💜🎮',
  ),
  'kpop': CertificadoMundo(
    slug: 'kpop',
    nome: 'Mundo K-Pop',
    corPrimaria: Color(0xFFFF6EC7),
    corSecundaria: Color(0xFF9B7BFF),
    pdfAsset: 'assets/pdfs/certificado_kpop.pdf', // TODO: PDF real do mundo
    mensagem:
        'Ai, {nome}, que orgulho! Você virou meu BIAS oficial. Explorou cada '
        'fancam deste planeta, cuidou do MAKNAE e ainda garantiu o COMEBACK '
        'mais lindo da galáxia. Eu STAN você pra sempre! Obrigadinho por '
        'ficar até o último encore. 💖✨',
  ),
  'pop': CertificadoMundo(
    slug: 'pop',
    nome: 'Mundo Pop',
    corPrimaria: Color(0xFFFFB020),
    corSecundaria: Color(0xFFFF5DA2),
    pdfAsset: 'assets/pdfs/certificado_pop.pdf', // TODO: PDF real do mundo
    mensagem:
        'Você veio pra LACRAR e conseguiu: SLAY total! Nada FLOPOU por aqui, '
        'nem mesmo eu no meu momento DELULU achando que você desistiria. '
        'Obrigadinho por explorar todo o Mundo Pop comigo, {nome}! 🌟🎤',
  ),
  'maquiagem': CertificadoMundo(
    slug: 'maquiagem',
    nome: 'Mundo Maquiagem',
    corPrimaria: Color(0xFFFF8FB1),
    corSecundaria: Color(0xFFC77DFF),
    pdfAsset:
        'assets/pdfs/certificado_maquiagem.pdf', // TODO: PDF real do mundo
    mensagem:
        'Que GLOW UP, {nome}, hein?! Você deixou este planeta com PELE DE '
        'VIDRO de tão brilhante. Fez um ESFUMADO perfeito em cada gírinha e '
        'ainda me emprestou o POSTIÇO pra foto final. Obrigadinho por '
        'explorar tudo com tanto capricho! 💄💫',
  ),
  'antigo': CertificadoMundo(
    slug: 'antigo',
    nome: 'Mundo Antigo',
    corPrimaria: Color(0xFFD9A441),
    corSecundaria: Color(0xFF8C6239),
    pdfAsset: 'assets/pdfs/certificado_antigo.pdf', // TODO: PDF real do mundo
    mensagem:
        'Mas que BAFAFÁ bonito você aprontou por aqui! Nada de BARBEIRO '
        'nesta viagem, nem CHÁ DE CADEIRA pra ninguém. Você é de BOA PINTA e '
        'explorou cada esquininha deste planeta vintage. Obrigadinho, '
        '{nome}! 📻💛',
  ),
  'cotidiano': CertificadoMundo(
    slug: 'cotidiano',
    nome: 'Mundo Cotidiano',
    corPrimaria: Color(0xFF4CC9F0),
    corSecundaria: Color(0xFF7C5CFF),
    pdfAsset:
        'assets/pdfs/certificado_cotidiano.pdf', // TODO: PDF real do mundo
    mensagem:
        'Zero CRINGE, muito RIZZ, {nome}! Você foi SIGMA do começo ao fim e '
        'nem precisou BISCOITAR pra brilhar. Obrigadinho por explorar cada '
        'cantinho do dia a dia deste planeta comigo. 🫶🌍',
  ),
  'esportes': CertificadoMundo(
    slug: 'esportes',
    nome: 'Mundo Esportes',
    corPrimaria: Color(0xFF3DDC84),
    corSecundaria: Color(0xFF00A6FB),
    pdfAsset:
        'assets/pdfs/certificado_esportes.pdf', // TODO: PDF real do mundo
    mensagem:
        'Ganhou DE LAVADA! Nada de MÃO DE ALFACE por aqui: você defendeu '
        'todas as gírias, soltou uma FIRULA no final e não fez nadinha de '
        'MIGUEZENTO. Obrigadinho por explorar o campo inteiro comigo, '
        '{nome}! ⚽🏆',
  ),
  'geek': CertificadoMundo(
    slug: 'geek',
    nome: 'Mundo Geek',
    corPrimaria: Color(0xFF00E5FF),
    corSecundaria: Color(0xFF6C4FC9),
    pdfAsset: 'assets/pdfs/certificado_geek.pdf', // TODO: PDF real do mundo
    mensagem:
        'OTAKU nível lendário, {nome}! Você maratonou este planeta sem '
        'pular nem um FILLER, cuidou da minha WAIFU e ainda apareceu de '
        'COSPLAY. Obrigadinho por explorar todo o Mundo Geek — sem SPOILER '
        'pros outros, combinado? 🤖💙',
  ),
  'redessociais': CertificadoMundo(
    slug: 'redessociais',
    nome: 'Mundo Redes Sociais',
    corPrimaria: Color(0xFF00C2FF),
    corSecundaria: Color(0xFFFF5DA2),
    pdfAsset:
        'assets/pdfs/certificado_redessociais.pdf', // TODO: PDF real do mundo
    mensagem:
        'Você TÁ NA DISNEY, {nome}! Explorou o feed inteiro sem criar RANÇO '
        'de ninguém, foi BISCOITEIRO só na dose certa e ainda STALKEOU todas '
        'as gírias escondidas. Obrigadinho por essa jornada 10/10! 📱💫',
  ),
  'relacionamentos': CertificadoMundo(
    slug: 'relacionamentos',
    nome: 'Mundo Relacionamentos',
    corPrimaria: Color(0xFFFF4D6D),
    corSecundaria: Color(0xFFC77DFF),
    pdfAsset:
        'assets/pdfs/certificado_relacionamentos.pdf', // TODO: PDF real do mundo
    mensagem:
        'Você virou meu CRUSH interplanetário! Nunca me deixou LEVAR BOLO, '
        'não foi TALARICO com nenhum outro mundo e apareceu em todos os '
        'DATE marcados. Obrigadinho por explorar cada cantinho, {nome}! 💘🚀',
  ),
};

/// Fallback usado quando o mundo não estiver mapeado acima.
CertificadoMundo certificadoDoMundo(String nomeOuSlug) {
  final slug = normalizarMundo(nomeOuSlug);
  return certificadosPorMundo[slug] ??
      CertificadoMundo(
        slug: slug,
        nome: nomeOuSlug,
        corPrimaria: const Color(0xFF7C5CFF),
        corSecundaria: const Color(0xFF32E0C4),
        // TODO: PDF genérico usado quando o mundo ainda não tem arquivo próprio.
        pdfAsset: 'assets/pdfs/certificado_padrao.pdf',
        mensagem:
            'Obrigadinho por explorar cada cantinho deste planeta comigo, '
            '{nome}! Você aprendeu todas as gírias daqui. 💜🚀',
      );
}