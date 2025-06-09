import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tudespensa/Utils/preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class ReportsProvider with ChangeNotifier {
  final prefs = Preferences();
  bool isLoading = false;
  String? errorMessage;
  final String baseUrl = 'http://192.168.1.5:4000/api';

  Future<String?> downloadReport() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;
      if (token.isEmpty) {
        errorMessage = "Token no encontrado";
        isLoading = false;
        notifyListeners();
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reports/generate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory == null) {
          errorMessage = "No se pudo acceder al almacenamiento";
          isLoading = false;
          notifyListeners();
          return null;
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${directory.path}/reporte_tudespensa_$timestamp.pdf';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        isLoading = false;
        notifyListeners();
        return filePath;
      } else {
        errorMessage = "Error al descargar el reporte (${response.statusCode})";
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = "Error de conexión: $e";
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMostBoughtReport({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;
      if (token.isEmpty) {
        throw Exception('Token no encontrado');
      }

      final queryParams = {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/shopping/reports/most-bought')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Retornar los datos tal como vienen del backend
      } else {
        throw Exception('Error al obtener el reporte: ${response.body}');
      }
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> downloadMostBoughtReportPDF({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 10,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;
      if (token.isEmpty) {
        throw Exception('Token no encontrado');
      }

      final queryParams = {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
        'limit': limit.toString(),
        'format': 'pdf',
      };

      final uri = Uri.parse('$baseUrl/shopping/reports/most-bought')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory == null) {
          throw Exception('No se pudo acceder al almacenamiento');
        }

        final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final fileName = 'reporte_productos_mas_comprados_$dateStr.pdf';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } else {
        throw Exception('Error al descargar el PDF: ${response.body}');
      }
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>?> getShoppingHistory({
    int page = 1,
    int limit = 10,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;
      if (token.isEmpty) {
        throw Exception('Token no encontrado');
      }

      final uri = Uri.parse('$baseUrl/shopping/history')
          .replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['historial']);
      } else {
        throw Exception('Error al obtener el historial: ${response.body}');
      }
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
