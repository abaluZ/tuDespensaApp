import 'package:flutter/material.dart';
import 'package:tudespensa/Models/shopping_item.dart';

class DespensaItemList extends StatelessWidget {
  final List<ShoppingItem> despensaItems;
  final Function(ShoppingItem) onItemRemoved;

  const DespensaItemList({
    Key? key,
    required this.despensaItems,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: despensaItems.length,
      itemBuilder: (context, index) {
        final item = despensaItems[index];
        return ListTile(
          title: Text('${item.nombre}'),
          subtitle: Text('${item.categoria} - ${item.cantidad} ${item.unidad}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onItemRemoved(item);
            },
          ),
        );
      },
    );
  }
}
