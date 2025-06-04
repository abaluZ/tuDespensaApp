import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/shopping_list_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/constants.dart';
import 'package:intl/intl.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/widgets/reports/most_bought_report_button.dart';

class ShoppingHistoryPage extends StatefulWidget {
  const ShoppingHistoryPage({Key? key}) : super(key: key);

  @override
  State<ShoppingHistoryPage> createState() => _ShoppingHistoryPageState();
}

class _ShoppingHistoryPageState extends State<ShoppingHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mover la carga inicial a después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<ShoppingListProvider>(context, listen: false);
      provider.fetchShoppingListHistory(context);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreHistory();
      }
    });
  }

  Future<void> _loadMoreHistory() async {
    final provider = Provider.of<ShoppingListProvider>(context, listen: false);
    if (!provider.isLoading && provider.currentPage < provider.totalPages) {
      await provider.fetchShoppingListHistory(
        context,
        page: provider.currentPage + 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MostBoughtReportButton(),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ShoppingListProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.historyItems.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.historyItems.isEmpty) {
                  return const Center(
                    child: Text('No hay historial de listas de compras'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.historyItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index == provider.historyItems.length) {
                      return provider.currentPage < provider.totalPages
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox();
                    }

                    final historyItem = provider.historyItems[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(
                          'Lista del ${DateFormat('dd/MM/yyyy HH:mm').format(historyItem.fechaCreacion)}',
                        ),
                        subtitle: Text(
                          'Items comprados: ${historyItem.itemsComprados}/${historyItem.totalItems}',
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: historyItem.items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = historyItem.items[itemIndex];
                              return ListTile(
                                leading: Icon(
                                  item.comprado
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: item.comprado
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                title: Text(item.nombre),
                                subtitle:
                                    Text('${item.cantidad} ${item.unidad}'),
                                trailing: Text(item.categoria),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
