import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/shopping_list_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/constants.dart';
import 'package:intl/intl.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/widgets/reports/most_bought_report_button.dart';
import 'package:tudespensa/pages/recipe_detail_page.dart';
import 'package:tudespensa/Utils/preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tudespensa/Models/recipe_model.dart';

class ShoppingHistoryPage extends StatefulWidget {
  const ShoppingHistoryPage({Key? key}) : super(key: key);

  @override
  State<ShoppingHistoryPage> createState() => _ShoppingHistoryPageState();
}

class _ShoppingHistoryPageState extends State<ShoppingHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  final prefs = Preferences();
  final String baseUrl = 'http://192.168.1.5:4000/api';
  String selectedMealType = 'desayuno';
  Map<String, List<dynamic>> historial = {
    'desayuno': [],
    'almuerzo': [],
    'cena': [],
    'postre': [],
  };
  bool isLoading = true;

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

  Future<void> fetchHistory() async {
    setState(() => isLoading = true);
    try {
      final token = prefs.authToken;
      final url = Uri.parse('$baseUrl/recipes/history');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          historial = Map<String, List<dynamic>>.from(
            decoded['historial'].map((k, v) => MapEntry(k, List<dynamic>.from(v)))
          );
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el historial')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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

  Widget _buildMealTypeButton(String value, String label) {
    final isSelected = selectedMealType == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedMealType = value;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(label),
      ),
    );
  }

  // Convierte el mapa de receta del historial a un modelo compatible con RecipeDetailPage
  Recipe _convertToRecipeModel(Map<String, dynamic> receta) {
    return Recipe(
      nombre: receta['nombre'] ?? '',
      descripcion: '',
      calorias: int.tryParse(receta['informacion_nutricional']?['calorias']?.toString() ?? '0') ?? 0,
      tiempo: receta['tiempo_preparacion'] ?? '-',
      dificultad: '',
      categoria: selectedMealType,
      ingredientes: (receta['ingredientes'] ?? receta['ingredientes_disponibles'] ?? []).map<String>((e) {
        if (e is Map && e['ingrediente'] != null && e['cantidad'] != null) {
          return '${e['ingrediente'] ?? e['nombre']}: ${e['cantidad']}';
        } else if (e is Map && e['nombre'] != null && e['cantidad'] != null) {
          return '${e['nombre']}: ${e['cantidad']}';
        } else if (e is String) {
          return e;
        } else {
          return e.toString();
        }
      }).toList(),
      pasos: (receta['preparacion'] ?? []).map<String>((e) => e.toString()).toList(),
      imagen: 'assets/images/recetas/default_recipe.png',
    );
  }
}
