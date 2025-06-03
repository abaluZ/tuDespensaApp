class Recipe {
  final String nombre;
  final String categoria;
  final int calorias;
  final String tiempo;
  final String dificultad;
  final String imagen;
  final List<String> ingredientes;
  final List<String> pasos;
  final String descripcion;

  Recipe({
    required this.nombre,
    required this.categoria,
    required this.calorias,
    required this.tiempo,
    required this.dificultad,
    required this.imagen,
    required this.ingredientes,
    required this.pasos,
    required this.descripcion,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      nombre: json['nombre'],
      categoria: json['categoria'],
      calorias: int.tryParse(json['calorias'].replaceAll(' kcal', '')) ?? 0,
      tiempo: json['tiempo'],
      dificultad: json['dificultad'],
      imagen: json['imagen'],
      ingredientes: List<String>.from(json['ingredientes']),
      pasos: List<String>.from(json['pasos']),
      descripcion: json['descripcion'],
    );
  }
}
