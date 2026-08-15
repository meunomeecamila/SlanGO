class Usuario {
  final int id;
  final String nome;
  final String email;
  final bool responsavel;
  final String? dataNascimento;
  final int? idade;
  final int? idAstronauta;
  final bool administrador;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.responsavel,
    this.dataNascimento,
    this.idade,
    this.idAstronauta,
    this.administrador = false,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    final dataNascimento = json['Data'] ?? json['dataNascimento'];
    final idade = _calcularIdade(dataNascimento);

    return Usuario(
      id: json['id'],
      nome: json['nome'] ?? json['Nome'],
      email: json['email'] ?? json['Email'],
      responsavel: json['responsavel'] ?? json['Responsavel'] ?? false,
      dataNascimento: dataNascimento,
      idade: idade,
      idAstronauta: json['idAstronauta'] ?? json['id_Astronauta'],
      administrador: json['administrador'] ?? json['Administrador'] ?? false,
    );
  }
}

int? _calcularIdade(Object? dataNascimento) {
  if (dataNascimento == null) return null;
  final data = DateTime.tryParse(dataNascimento.toString());
  if (data == null) return null;

  final hoje = DateTime.now();
  var idade = hoje.year - data.year;
  if (hoje.month < data.month ||
      (hoje.month == data.month && hoje.day < data.day)) {
    idade--;
  }
  return idade;
}