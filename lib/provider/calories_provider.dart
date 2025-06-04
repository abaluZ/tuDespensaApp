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
  final String baseUrl = 'http://192.168.0.57:4000/api';

  Future<CaloriesModel?> fetchCaloriesData() async {
    print('[CaloriesProvider] Iniciando carga de datos de calorías...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;

      if (token.isEmpty) {
        _errorMessage = "Token no encontrado";
        print("[CaloriesProvider] Error: Token no encontrado");
        _isLoading = false;
        notifyListeners();
        return null;
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
        try {
          final decodedBody = json.decode(response.body);
          print('[CaloriesProvider] Respuesta decodificada:');
          print(const JsonEncoder.withIndent('  ').convert(decodedBody));

          _caloriesModel = CaloriesModel.fromJson(decodedBody);
          print('[CaloriesProvider] Modelo creado exitosamente');
          print('[CaloriesProvider] Datos cargados:');
          print('- Mensaje: ${_caloriesModel?.message}');
          print('- Calorías diarias: ${_caloriesModel?.data.caloriasDiarias}');
          print('- TMB: ${_caloriesModel?.data.tmb}');
          print('\nMacronutrientes:');
          print(
              '- Proteínas: ${_caloriesModel?.data.macronutrientes.proteinas}g');
          print('- Grasas: ${_caloriesModel?.data.macronutrientes.grasas}g');
          print(
              '- Carbohidratos: ${_caloriesModel?.data.macronutrientes.carbohidratos}g');
          print('\nDistribución calórica:');
          print(
              '- Desayuno: ${_caloriesModel?.data.distribucionCalorica.desayuno} kcal');
          print(
              '- Almuerzo: ${_caloriesModel?.data.distribucionCalorica.almuerzo} kcal');
          print(
              '- Cena: ${_caloriesModel?.data.distribucionCalorica.cena} kcal');
          print(
              '- Meriendas: ${_caloriesModel?.data.distribucionCalorica.meriendas} kcal');

          _isLoading = false;
          notifyListeners();
          return _caloriesModel;
        } catch (e) {
          print("[CaloriesProvider] Error al procesar JSON: $e");
          print("[CaloriesProvider] Respuesta que causó el error:");
          print(response.body);
          _errorMessage = "Error al procesar la respuesta del servidor";
          _isLoading = false;
          notifyListeners();
          return null;
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        _errorMessage = "Sesión expirada o no autorizada";
        print("[CaloriesProvider] Error: Sesión expirada o no autorizada");
        _isLoading = false;
        notifyListeners();
        return null;
      } else {
        _errorMessage = "Error del servidor (${response.statusCode})";
        print("[CaloriesProvider] Error del servidor: ${response.statusCode}");
        print("[CaloriesProvider] Respuesta:");
        print(response.body);
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e, stackTrace) {
      _errorMessage = "Error de conexión";
      print("[CaloriesProvider] Error de excepción: $e");
      print("[CaloriesProvider] Stack trace: $stackTrace");
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearCaloriesData() {
    print('[CaloriesProvider] Limpiando datos de calorías');
    _caloriesModel = null;
    notifyListeners();
  }

  Future<void> fetchCalories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.getCalories();
      _caloriesModel = CaloriesModel.fromJson(response);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _caloriesModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
