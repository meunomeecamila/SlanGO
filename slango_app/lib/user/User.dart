class Usuario {
  final int id;
  final String nome;
  final String email;
  final bool responsavel;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.responsavel,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'] ?? json['Nome'],
      email: json['email'] ?? json['Email'],
      responsavel: json['responsavel'] ?? json['Responsavel'] ?? false,
    );
  }
}