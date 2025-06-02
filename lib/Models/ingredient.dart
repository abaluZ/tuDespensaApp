class Ingredient {
  final String id;
  final String nombre;
  final String tipo;

  Ingredient({
    required this.id,
    required this.nombre,
    required this.tipo,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['_id'],
      nombre: map['nombre'],
      tipo: map['tipo'],
    );
  }
}
