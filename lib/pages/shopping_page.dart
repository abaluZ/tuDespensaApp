import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/Models/shopping_item.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/provider/shopping_list_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/shopping/shopping_item_list.dart';
import 'package:tudespensa/widgets/shopping/show_dialog_add.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
    final shoppingListProvider =
        Provider.of<ShoppingListProvider>(context, listen: false);
    shoppingListProvider.fetchShoppingList(context);
  }

  void _agregarItem(ShoppingItem item) {
    final shoppingListProvider =
        Provider.of<ShoppingListProvider>(context, listen: false);
    shoppingListProvider.addItem(item);
  }

  void _itemChanged(ShoppingItem item) {
    final shoppingListProvider =
        Provider.of<ShoppingListProvider>(context, listen: false);
    shoppingListProvider.updateItem(item);
  }

  void _removeItem(ShoppingItem item) {
    final shoppingListProvider =
        Provider.of<ShoppingListProvider>(context, listen: false);
    shoppingListProvider.removeItem(item);
  }

  void _saveOrUpdateList() {
    final shoppingListProvider =
        Provider.of<ShoppingListProvider>(context, listen: false);
    shoppingListProvider.saveOrUpdateShoppingList(context);
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      appBar: AppBarDespensa(
        backgroundColor: BackgroundColor,
        onBack: () => Navigator.pop(context),
        onAvatarTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserPage()),
          );
        },
        logoPath: 'assets/images/logo.png',
        avatarPath: 'assets/images/icon.png',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            EncabezadoConImagen(
              texto: "Lista de\nCompras",
              rutaImagen: 'assets/images/despensaPage.png',
              colorTexto: Colors.black,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => mostrarDialogoAgregar(context, _agregarItem),
              child: const Text('Agregar'),
            ),
            const SizedBox(height: 20),
            ShoppingItemList(
              shoppingItems: shoppingListProvider.shoppingItems,
              onItemChanged: _itemChanged,
              onItemRemoved: _removeItem,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _saveOrUpdateList,
                  child: const Text('Guardar Lista'),
                ),
                ElevatedButton(
                  onPressed: _saveOrUpdateList,
                  child: const Text('Actualizar Lista'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
