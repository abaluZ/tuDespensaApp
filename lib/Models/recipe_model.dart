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
      nombre: json['nombre'] ?? 'Sin nombre',
      categoria: json['categoria'] ?? 'Sin categoría',
      calorias: int.tryParse((json['calorias'] ?? '0').toString().replaceAll(' kcal', '')) ?? 0,
      tiempo: json['tiempo'] ?? '0 min',
      dificultad: json['dificultad'] ?? 'No especificada',
      imagen: json['imagen'] ?? 'assets/images/recetas/default_recipe.png',
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
      pasos: List<String>.from(json['pasos'] ?? []),
      descripcion: json['descripcion'] ?? 'Sin descripción',
    );
  }
}
