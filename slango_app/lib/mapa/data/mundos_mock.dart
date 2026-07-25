import '../models/mundo.dart';

final List<Mundo> mundos = [
  const Mundo(
    nome: 'Mundo Jogos',
    imagem: 'images/mundo.png',
    descricao: 'Disponível',
    totalGirias: 5,
    progresso: 0.40,
    desbloqueado: true,
  ),
  const Mundo(
    nome: 'Mundo K-Pop',
    imagem: 'images/mundo.png',
    descricao: 'Em breve',
    totalGirias: 6,
    progresso: 0.0,
    desbloqueado: false,
  ),
  const Mundo(
    nome: 'Mundo Maquiagem',
    imagem: 'images/mundo.png',
    descricao: 'Em breve',
    totalGirias: 8,
    progresso: 0.0,
    desbloqueado: false,
  ),
  const Mundo(
    nome: 'Mundo Pop',
    imagem: 'images/mundo.png',
    descricao: 'Em breve',
    totalGirias: 7,
    progresso: 0.0,
    desbloqueado: false,
  ),
];