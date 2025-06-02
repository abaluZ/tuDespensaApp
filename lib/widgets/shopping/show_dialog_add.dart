import 'package:flutter/material.dart';
import 'package:tudespensa/Data/food_list.dart';
import 'package:tudespensa/Models/shopping_item.dart';
import 'package:uuid/uuid.dart';

void mostrarDialogoAgregar(
    BuildContext context, Function(ShoppingItem) onAddItem) {
  String? ingredienteSeleccionado;
  double cantidad = 1;
  String unidadSeleccionada = 'unidades';
  List<String> unidades = ['unidades', 'g', 'kg', 'ml', 'l'];
  final uuid = Uuid();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar Alimento'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Alimento'),
                  value: ingredienteSeleccionado,
                  items: foodList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['Nombre'],
                      child: Text(item['Nombre']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => ingredienteSeleccionado = value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  onChanged: (value) {
                    cantidad = double.tryParse(value) ?? 1;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Unidad'),
                  value: unidadSeleccionada,
                  items: unidades.map((u) {
                    return DropdownMenuItem(value: u, child: Text(u));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => unidadSeleccionada = value!);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              final selectedIngredient = foodList.firstWhere(
                  (item) => item['Nombre'] == ingredienteSeleccionado);
              final newItem = ShoppingItem(
                id: uuid.v4(),
                nombre: selectedIngredient['Nombre']!,
                categoria: selectedIngredient['Categoria']!,
                cantidad: cantidad,
                unidad: unidadSeleccionada,
              );
              onAddItem(newItem);
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}
