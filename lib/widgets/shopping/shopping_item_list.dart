import 'package:flutter/material.dart';
import 'package:tudespensa/Models/shopping_item.dart';

class ShoppingItemList extends StatelessWidget {
  final List<ShoppingItem> shoppingItems;
  final Function(ShoppingItem) onItemChanged;
  final Function(ShoppingItem) onItemRemoved;

  const ShoppingItemList({
    Key? key,
    required this.shoppingItems,
    required this.onItemChanged,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shoppingItems.length,
      itemBuilder: (context, index) {
        final item = shoppingItems[index];
        return ListTile(
          title: Text('${item.nombre} (${item.cantidad} ${item.unidad})'),
          subtitle: Text(item.categoria),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: item.comprado,
                onChanged: (value) {
                  final updatedItem = item.copyWith(comprado: value!);
                  onItemChanged(updatedItem);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onItemRemoved(item);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
