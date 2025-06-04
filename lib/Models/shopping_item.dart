// models/shopping_item.dart
class ShoppingItem {
  final String id;
  final String nombre;
  final String categoria;
  final double cantidad;
  final String unidad;
  bool comprado;

  ShoppingItem({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.unidad,
    this.comprado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'cantidad': cantidad,
      'unidad': unidad,
      'comprado': comprado,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      categoria: map['categoria']?.toString() ?? 'Sin categoría',
      cantidad: (map['cantidad'] is num) ? (map['cantidad'] as num).toDouble() : 0.0,
      unidad: map['unidad']?.toString() ?? 'unidad',
      comprado: map['comprado'] ?? false,
    );
  }

  ShoppingItem copyWith({
    String? id,
    String? nombre,
    String? categoria,
    double? cantidad,
    String? unidad,
    bool? comprado,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
      comprado: comprado ?? this.comprado,
    );
  }
}
