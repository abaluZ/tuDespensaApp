class UserModel {
  final String username;
  final String email;
  final String role;
  final String id;
  final String plan;
  final String goal;
  final String nombre;
  final String apellidos;
  final String estatura;
  final String peso;
  final String edad;
  final String genero;
  final String? profilePhoto;

  UserModel({
    required this.username,
    required this.id,
    required this.email,
    required this.role,
    required this.plan,
    required this.goal,
    required this.nombre,
    required this.apellidos,
    required this.estatura,
    required this.peso,
    required this.edad,
    required this.genero,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String formatearFecha(String fecha) {
      if (fecha.contains('T')) {
        return fecha.split('T')[0];
      }
      return fecha;
    }

    return UserModel(
      id: json['user']['id'] ?? 'Sin nombre',
      username: json['user']['username'] ?? 'Sin nombre',
      email: json['user']['email'] ?? '',
      role: json['user']['role'] ?? '',
      plan: json['user']['plan'] ?? '',
      goal: json['goal']['goal'] ?? '',
      nombre: json['information']['Nombre'] ?? '',
      apellidos: json['information']['Apellidos'] ?? '',
      estatura: json['information']['Estatura'] ?? '',
      peso: json['information']['Peso'] ?? '',
      edad: formatearFecha(json['information']['Edad'] ?? ''),
      genero: json['information']['Genero'] ?? '',
      profilePhoto: json['user']['profilePhoto'],
    );
  }
}
