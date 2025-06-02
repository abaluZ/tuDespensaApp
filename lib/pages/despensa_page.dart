import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/Models/shopping_item.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/provider/despensa_user_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/despensa/despensa_item_list.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/shopping/show_dialog_add.dart';

class DespensaPage extends StatefulWidget {
  const DespensaPage({super.key});

  @override
  State<DespensaPage> createState() => _DespensaPageState();
}

class _DespensaPageState extends State<DespensaPage> {
  @override
  void initState() {
    super.initState();
    final despensaProvider =
        Provider.of<DespensaUserProvider>(context, listen: false);
    despensaProvider.fetchDespensaList(context);
  }

  void _agregarItem(ShoppingItem item) {
    final despensaProvider =
        Provider.of<DespensaUserProvider>(context, listen: false);
    despensaProvider.addItem(item);
  }

  void _removeItem(ShoppingItem item) {
    final despensaProvider =
        Provider.of<DespensaUserProvider>(context, listen: false);
    despensaProvider.removeItem(item);
  }

  void _saveOrUpdateList() {
    final despensaProvider =
        Provider.of<DespensaUserProvider>(context, listen: false);
    despensaProvider.saveOrUpdateDespensaList(context);
  }

  @override
  Widget build(BuildContext context) {
    final despensaProvider = Provider.of<DespensaUserProvider>(context);
    final despensaItems = despensaProvider.shoppingItems;

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
              texto: "Despensa",
              rutaImagen: 'assets/images/despensaPage.png',
              colorTexto: Colors.black,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => mostrarDialogoAgregar(context, _agregarItem),
              child: const Text('Agregar'),
            ),
            const SizedBox(height: 20),
            DespensaItemList(
              despensaItems: despensaItems,
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
