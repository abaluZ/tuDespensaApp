class MostBoughtItem {
  final String nombre;
  final String categoria;
  final int cantidadComprada;
  final String unidadMasComun;

  MostBoughtItem({
    required this.nombre,
    required this.categoria,
    required this.cantidadComprada,
    required this.unidadMasComun,
  });

  factory MostBoughtItem.fromMap(Map<String, dynamic> map) {
    return MostBoughtItem(
      nombre: map['nombre'] ?? '',
      categoria: map['categoria'] ?? '',
      cantidadComprada: map['cantidadComprada'] ?? 0,
      unidadMasComun: map['unidadMasComun'] ?? '',
    );
  }
}

class MostBoughtReport {
  final List<MostBoughtItem> items;
  final DateTime startDate;
  final DateTime endDate;

  MostBoughtReport({
    required this.items,
    required this.startDate,
    required this.endDate,
  });

  factory MostBoughtReport.fromMap(Map<String, dynamic> map) {
    return MostBoughtReport(
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => MostBoughtItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      startDate:
          DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(map['endDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
