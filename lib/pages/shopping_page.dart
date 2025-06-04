import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/Models/shopping_item.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/pages/shopping_history_page.dart';
import 'package:tudespensa/provider/shopping_list_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/shopping/shopping_item_list.dart';
import 'package:tudespensa/widgets/shopping/show_dialog_add.dart';
import 'package:tudespensa/widgets/reports/most_bought_report_button.dart';

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

  Future<void> _saveOrUpdateList({bool completar = false}) async {
    final shoppingListProvider =
        Provider.of<ShoppingListProvider>(context, listen: false);
    await shoppingListProvider.saveOrUpdateShoppingList(context,
        completar: completar);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => mostrarDialogoAgregar(context, _agregarItem),
                  child: const Text('Agregar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingHistoryPage(),
                      ),
                    );
                  },
                  child: const Text('Ver Historial'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: MostBoughtReportButton(),
            ),
            const SizedBox(height: 20),
            ShoppingItemList(
              shoppingItems: shoppingListProvider.shoppingItems,
              onItemChanged: _itemChanged,
              onItemRemoved: _removeItem,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _saveOrUpdateList(),
                  child: const Text('Guardar Lista'),
                ),
                ElevatedButton(
                  onPressed: () => _saveOrUpdateList(completar: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Completar Lista'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
