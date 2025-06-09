import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tudespensa/Models/calories_model.dart';
import 'package:tudespensa/Utils/preferences.dart';
import '../services/api_service.dart';

class CaloriesProvider with ChangeNotifier {
  final prefs = Preferences();
  CaloriesModel? _caloriesModel;
  bool _isLoading = false;
  String? _errorMessage;

  CaloriesModel? get caloriesModel => _caloriesModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getter para acceder directamente a las calorías
  CaloriesData? get calories => _caloriesModel?.data;

  // URL base del backend
  final String baseUrl = 'http://192.168.1.5:4000/api';

  Future<CaloriesModel?> fetchCaloriesData() async {
    if (_isLoading) return _caloriesModel;
    
    print('[CaloriesProvider] Iniciando carga de datos de calorías...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;

      if (token.isEmpty) {
        throw Exception('Token no encontrado');
      }

      final url = '$baseUrl/calorias';
      print('[CaloriesProvider] Realizando petición a: $url');


      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('[CaloriesProvider] Código de respuesta: ${response.statusCode}');
      print('[CaloriesProvider] Cuerpo de la respuesta:');
      print(response.body);

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        _caloriesModel = CaloriesModel.fromJson(decodedBody);
        _errorMessage = null;
        print('[CaloriesProvider] Datos cargados exitosamente');
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        throw Exception('Sesión expirada o no autorizada');
      } else {
        throw Exception('Error del servidor (${response.statusCode})');
      }
    } catch (e) {
      print('[CaloriesProvider] Error: $e');
      _errorMessage = e.toString();
      _caloriesModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    return _caloriesModel;
  }

  // Alias para mantener compatibilidad
  Future<void> fetchCalories() => fetchCaloriesData();

  void clearCaloriesData() {
    print('[CaloriesProvider] Limpiando datos de calorías');
    _caloriesModel = null;
    notifyListeners();
  }
}