import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tudespensa/Utils/preferences.dart';

class ReportsProvider with ChangeNotifier {
  final prefs = Preferences();
  bool isLoading = false;
  String? errorMessage;
  final String baseUrl = 'http://192.168.0.12:4000/api';

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
}
