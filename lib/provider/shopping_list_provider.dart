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

class ShoppingListProvider extends ChangeNotifier {
  final String baseUrl =
      'http://192.168.1.5:4000/api'; // ajusta si usas IP local o deploy


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
        Uri.parse('$baseUrl/shopping-list'),
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
          _shoppingItems = []; // Limpiar la lista actual si se completó
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
        Uri.parse('$baseUrl/shopping-list'),
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
      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();

      if (token == null) {
        print("Token no encontrado");
        _setLoading(false);
        return false;
      }

      final res = await http.get(
        Uri.parse('$baseUrl/shopping-list/history?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print("Respuesta del servidor: ${res.body}"); // Debug log

        if (data['historial'] == null) {
          print("El historial es nulo en la respuesta");
          _setLoading(false);
          return false;
        }

        if (page == 1) {
          _historyItems = [];
        }

        final newItems = (data['historial'] as List)
            .map((item) => ShoppingListHistory.fromMap(item))
            .toList();

        _historyItems.addAll(newItems);
        _currentPage = data['currentPage'] ?? page;
        _totalPages = data['totalPages'] ?? 1;

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        print("Error al obtener el historial: ${res.body}");
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

      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();

      if (token == null) {
        print("Token no encontrado");
        return;
      }

      final queryParams = {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/reports/shopping/most-bought')
          .replace(queryParameters: queryParams);

      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/octet-stream',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (context.mounted) {
          _showReportDialog(context, data, startDate, endDate);
        }
      } else {
        print("Error al obtener el reporte: ${res.body}");
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

  Future<void> _downloadAndOpenPDF(
      BuildContext context, DateTime startDate, DateTime endDate) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Generando reporte PDF...'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();
      if (token == null) return;

      final queryParams = {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };

      final uri = Uri.parse('$baseUrl/reports/shopping/history/report')
          .replace(queryParameters: queryParams);

      print('Intentando descargar PDF desde: $uri');

      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/pdf',
        },
      );

      print('Respuesta del servidor:');
      print('Status code: ${res.statusCode}');
      print('Headers: ${res.headers}');
      print('Content-Type: ${res.headers['content-type']}');

      if (res.statusCode == 200) {
        // Verificar si recibimos datos binarios
        if (res.headers['content-type']?.contains('application/pdf') == true ||
            res.headers['content-type']?.contains('application/octet-stream') ==
                true ||
            res.headers['content-disposition']?.contains('attachment') ==
                true) {
          final directory = await getApplicationDocumentsDirectory();
          final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
          final fileName = 'reporte_productos_$dateStr.pdf';
          final filePath = '${directory.path}/$fileName';

          print('Guardando PDF en: $filePath');
          print('Tamaño del archivo: ${res.bodyBytes.length} bytes');

          final file = File(filePath);
          await file.writeAsBytes(res.bodyBytes);

          print('PDF guardado, intentando abrir...');

          if (context.mounted) {
            final result = await OpenFile.open(filePath);
            print(
                'Resultado de abrir archivo: ${result.type} - ${result.message}');

            if (result.type == ResultType.done) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporte PDF generado con éxito'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al abrir el archivo: ${result.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          // Si recibimos JSON en lugar de PDF, probablemente sea un mensaje de error
          final errorData = jsonDecode(res.body);
          throw Exception(
              errorData['message'] ?? 'Error desconocido al generar el PDF');
        }
      } else {
        print('Error: El servidor no devolvió un PDF válido');
        print('Content-Type recibido: ${res.headers['content-type']}');

        if (context.mounted) {
          String errorMessage = 'Error al descargar el PDF\n';
          if (res.headers['content-type']?.contains('application/json') ==
              true) {
            final errorData = jsonDecode(res.body);
            errorMessage += errorData['message'] ?? 'Error desconocido';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Error detallado al descargar PDF: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al descargar el PDF: $e'),
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
          TextButton.icon(
            onPressed: () {
              _downloadAndOpenPDF(context, startDate, endDate);
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Descargar PDF'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
