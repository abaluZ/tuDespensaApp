import 'shopping_item.dart';

class ShoppingListHistory {
  final String id;
  final List<ShoppingItem> items;
  final bool completada;
  final DateTime fechaCreacion;
  final DateTime? fechaCompletado;
  final int totalItems;
  final int itemsComprados;

  ShoppingListHistory({
    required this.id,
    required this.items,
    required this.completada,
    required this.fechaCreacion,
    this.fechaCompletado,
    required this.totalItems,
    required this.itemsComprados,
  });

  factory ShoppingListHistory.fromMap(Map<String, dynamic> map) {
    return ShoppingListHistory(
      id: map['_id'] ?? map['id'] ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => ShoppingItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      completada: map['completada'] ?? false,
      fechaCreacion: DateTime.parse(
          map['fechaCreacion'] ?? DateTime.now().toIso8601String()),
      fechaCompletado: map['fechaCompletado'] != null
          ? DateTime.parse(map['fechaCompletado'])
          : null,
      totalItems: map['totalItems'] ?? 0,
      itemsComprados: map['itemsComprados'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'completada': completada,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaCompletado': fechaCompletado?.toIso8601String(),
      'totalItems': totalItems,
      'itemsComprados': itemsComprados,
    };
  }
}
