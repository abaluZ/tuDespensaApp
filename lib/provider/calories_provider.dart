import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tudespensa/Models/calories_model.dart';
import 'package:tudespensa/Utils/preferences.dart';

class CaloriesProvider with ChangeNotifier {
  final prefs = Preferences();
  CaloriesModel? caloriesModel;

  bool isLoading = false;
  String? errorMessage;

  // URL base del backend
  final String baseUrl = 'http://192.168.0.12:4000/api';

  Future<CaloriesModel?> fetchCaloriesData() async {
    print('[CaloriesProvider] Iniciando carga de datos de calorías...');
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;

      if (token.isEmpty) {
        errorMessage = "Token no encontrado";
        print("[CaloriesProvider] Error: Token no encontrado");
        isLoading = false;
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

          caloriesModel = CaloriesModel.fromJson(decodedBody);
          print('[CaloriesProvider] Modelo creado exitosamente');
          print('[CaloriesProvider] Datos cargados:');
          print('- Mensaje: ${caloriesModel?.message}');
          print('- Calorías diarias: ${caloriesModel?.data.caloriasDiarias}');
          print('- TMB: ${caloriesModel?.data.tmb}');
          print('\nMacronutrientes:');
          print(
              '- Proteínas: ${caloriesModel?.data.macronutrientes.proteinas}g');
          print('- Grasas: ${caloriesModel?.data.macronutrientes.grasas}g');
          print(
              '- Carbohidratos: ${caloriesModel?.data.macronutrientes.carbohidratos}g');
          print('\nDistribución calórica:');
          print(
              '- Desayuno: ${caloriesModel?.data.distribucionCalorica.desayuno} kcal');
          print(
              '- Almuerzo: ${caloriesModel?.data.distribucionCalorica.almuerzo} kcal');
          print(
              '- Cena: ${caloriesModel?.data.distribucionCalorica.cena} kcal');
          print(
              '- Meriendas: ${caloriesModel?.data.distribucionCalorica.meriendas} kcal');

          isLoading = false;
          notifyListeners();
          return caloriesModel;
        } catch (e) {
          print("[CaloriesProvider] Error al procesar JSON: $e");
          print("[CaloriesProvider] Respuesta que causó el error:");
          print(response.body);
          errorMessage = "Error al procesar la respuesta del servidor";
          isLoading = false;
          notifyListeners();
          return null;
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        errorMessage = "Sesión expirada o no autorizada";
        print("[CaloriesProvider] Error: Sesión expirada o no autorizada");
        isLoading = false;
        notifyListeners();
        return null;
      } else {
        errorMessage = "Error del servidor (${response.statusCode})";
        print("[CaloriesProvider] Error del servidor: ${response.statusCode}");
        print("[CaloriesProvider] Respuesta:");
        print(response.body);
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e, stackTrace) {
      errorMessage = "Error de conexión";
      print("[CaloriesProvider] Error de excepción: $e");
      print("[CaloriesProvider] Stack trace: $stackTrace");
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearCaloriesData() {
    print('[CaloriesProvider] Limpiando datos de calorías');
    caloriesModel = null;
    notifyListeners();
  }
}
