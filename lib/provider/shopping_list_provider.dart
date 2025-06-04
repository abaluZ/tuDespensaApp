import 'dart:convert';
import 'dart:io';
import 'dart:math';
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
  final String baseUrl = 'http://192.168.1.5:4000/api';

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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo y título
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Reporte de Compras',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Tipo de reporte y período
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de Reporte: ${report['reportType']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Estadísticas Generales
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estadísticas Generales',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total de listas analizadas: ${report['totalLists'] ?? 0}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Total de productos únicos: ${report['uniqueProducts'] ?? 0}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Productos más comprados
                Text(
                  'Productos Más Comprados',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  (report['products'] as List? ?? []).length,
                  (index) {
                    final product = (report['products'] as List)[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${index + 1}. ${product['name']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Veces: ${product['count']}',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (product['category'] != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Categoría: ${product['category']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Gráfico de frecuencia
                Text(
                  'Gráfico de Frecuencia de Compras',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildFrequencyBars(report['products'] as List? ?? []),
                const SizedBox(height: 16),
                // Fecha de generación
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Reporte generado el: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                final filePath = await downloadMostBoughtReportPDF(
                  context,
                  startDate: startDate,
                  endDate: endDate,
                );
                if (filePath != null) {
                  await OpenFile.open(filePath);
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Descargar PDF'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[700],
              ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Cerrar'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
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

  List<Widget> _buildFrequencyBars(List products) {
    final maxCount = products.isEmpty
        ? 1
        : (products.map((p) => p['count'] as int).reduce(max)).toDouble();

    return products.map((product) {
      final count = (product['count'] as int).toDouble();
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    product['name'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: count / maxCount,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${count.toInt()})',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
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
