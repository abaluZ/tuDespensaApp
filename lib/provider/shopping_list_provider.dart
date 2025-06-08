import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tudespensa/Models/shopping_item.dart';
import 'package:tudespensa/Models/shopping_list_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'auth_provider.dart';
import 'reports_provider.dart';

class ShoppingListProvider extends ChangeNotifier {
  final String baseUrl = 'http://192.168.1.4:4000/api';

  List<ShoppingItem> _shoppingItems = [];
  List<ShoppingListHistory> _historyItems = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 0;

  List<ShoppingItem> get shoppingItems => _shoppingItems;
  List<ShoppingListHistory> get historyItems => _historyItems;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> saveOrUpdateShoppingList(BuildContext context,
      {bool completar = false}) async {
    try {
      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();

      if (token == null) {
        print("Token no encontrado");
        _setLoading(false);
        return false;
      }

      final res = await http.post(
        Uri.parse('$baseUrl/shopping/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'items': _shoppingItems.map((item) => item.toMap()).toList(),
          'completar': completar,
        }),
      );

      _setLoading(false);

      if (res.statusCode == 200) {
        print(
            "Lista de compras ${completar ? 'completada' : 'guardada/actualizada'} correctamente");
        if (completar) {
          _shoppingItems = [];
          notifyListeners();
        }
        return true;
      } else {
        print(
            "Error al ${completar ? 'completar' : 'guardar/actualizar'} la lista de compras: ${res.body}");
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print("Error en saveOrUpdateShoppingList: $e");
      return false;
    }
  }

  Future<bool> fetchShoppingList(BuildContext context) async {
    try {
      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();

      if (token == null) {
        print("Token no encontrado");
        _setLoading(false);
        return false;
      }

      final res = await http.get(
        Uri.parse('$baseUrl/shopping/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      _setLoading(false);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _shoppingItems = (data['items'] as List)
            .map((item) => ShoppingItem.fromMap(item))
            .toList();
        notifyListeners();
        print("Lista de compras obtenida correctamente");
        return true;
      } else {
        print("Error al obtener la lista de compras: ${res.body}");
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print("Error en fetchShoppingList: $e");
      return false;
    }
  }

  Future<bool> fetchShoppingListHistory(BuildContext context,
      {int page = 1, int limit = 10}) async {
    try {
      _setLoading(true);
      
      final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      final historyData = await reportsProvider.getShoppingHistory(
        page: page,
        limit: limit,
      );

      if (historyData != null) {
        if (page == 1) {
          _historyItems = [];
        }

        final newItems = historyData
            .map((item) => ShoppingListHistory.fromMap(item))
            .toList();

        _historyItems.addAll(newItems);
        _currentPage = page;
        _totalPages = (historyData.length / limit).ceil();

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        print("Error al obtener el historial: ${reportsProvider.errorMessage}");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print("Error detallado en fetchShoppingListHistory: $e");
      _setLoading(false);
      return false;
    }
  }

  void addItem(ShoppingItem item) {
    _shoppingItems.add(item);
    notifyListeners();
  }

  void removeItem(ShoppingItem item) {
    _shoppingItems.remove(item);
    notifyListeners();
  }

  void updateItem(ShoppingItem item) {
    final index = _shoppingItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _shoppingItems[index] = item;
      notifyListeners();
    }
  }

  void clearCurrentList() {
    _shoppingItems = [];
    notifyListeners();
  }

  Future<void> getMostBoughtReport(
    BuildContext context, {
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Generando reporte...'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      final reportData = await reportsProvider.getMostBoughtReport(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      if (reportData != null) {
        if (context.mounted) {
          _showReportDialog(context, reportData, startDate, endDate);
        }
      } else {
        print("Error al obtener el reporte: ${reportsProvider.errorMessage}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al generar el reporte'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Error en getMostBoughtReport: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al generar el reporte'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showReportDialog(BuildContext context, Map<String, dynamic> data,
      DateTime startDate, DateTime endDate) {
    final estadisticas = data['estadisticas'];
    final productos = data['productos'] as List;
    final dateFormat = DateFormat('dd/MM/yyyy');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reporte de Productos Más Comprados'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Período: ${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Total de Listas: ${estadisticas['totalListas']}'),
              Text(
                  'Total de Productos Únicos: ${estadisticas['totalProductosUnicos']}'),
              const SizedBox(height: 16),
              if (productos.isEmpty)
                const Text(
                  'No hay productos comprados en este período',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              else ...[
                const Text(
                  'Productos más comprados:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...productos.map((producto) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(producto['nombre'] ?? ''),
                                Text(
                                  producto['categoria'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${producto['cantidadComprada'] ?? 0} ${producto['unidadMasComun'] ?? ''}',
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void showMostBoughtReport(BuildContext context) async {
    final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));
    final endDate = now;

    final report = await reportsProvider.getMostBoughtReport(
      startDate: startDate,
      endDate: endDate,
    );

    if (report != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reporte de Productos Más Comprados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Período: ${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}'),
              const SizedBox(height: 8),
              Text('Total de Listas: ${report['totalLists'] ?? 0}'),
              Text('Total de Productos Únicos: ${report['uniqueProducts'] ?? 0}'),
              const SizedBox(height: 16),
              const Text('Productos más comprados:'),
              const SizedBox(height: 8),
              ...List.generate(
                (report['products'] as List? ?? []).length,
                (index) {
                  final product = (report['products'] as List)[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product['name'] ?? ''),
                        Text('${product['count'] ?? 0}'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final filePath = await reportsProvider.downloadMostBoughtReportPDF(
                  startDate: startDate,
                  endDate: endDate,
                );
                
                if (filePath != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reporte guardado en: $filePath'),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                  await OpenFile.open(filePath);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al descargar el reporte PDF'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Descargar PDF'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al generar el reporte'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> downloadMostBoughtReportPDF(
    BuildContext context, {
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Descargando reporte PDF...'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      final filePath = await reportsProvider.downloadMostBoughtReportPDF(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      if (filePath != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte PDF descargado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
        return filePath;
      } else {
        print("Error al descargar el reporte PDF: ${reportsProvider.errorMessage}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al descargar el reporte PDF'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      }
    } catch (e) {
      print("Error en downloadMostBoughtReportPDF: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al descargar el reporte PDF'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }
}
