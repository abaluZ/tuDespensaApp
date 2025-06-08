import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tudespensa/Utils/preferences.dart';

enum DietType {
  estandar,
  vegetariana,
}

class TypeDietProvider extends ChangeNotifier {
  final prefs = Preferences();
  static const String _baseUrl = 'http://192.168.1.4:4000/api';

  DietType? _selectedDiet;
  bool _hasSavedDiet = false;
  bool get hasSavedDiet => _hasSavedDiet;
  DietType? get selectedDiet => _selectedDiet;

  Future<void> changeDiet(DietType diet) async {
    _selectedDiet = diet;
    notifyListeners();
  }

  Future<bool> saveDiet() async {
    if (_selectedDiet == null) return false;

    try {
      final token = prefs.authToken;
      if (token == null || token.isEmpty) {
        print('Error: No hay token de autenticación');
        return false;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/diet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type_diet': dietAsText,
        }),
      );

      print('Respuesta del servidor: ${response.body}');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _hasSavedDiet = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al guardar la dieta: $e');
      return false;
    }
  }

  Future<bool> updateDiet() async {
    if (_selectedDiet == null) return false;

    try {
      final token = prefs.authToken;
      if (token == null || token.isEmpty) {
        print('Error: No hay token de autenticación');
        return false;
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/diet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type_diet': dietAsText,
        }),
      );

      print('Respuesta del servidor: ${response.body}');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al actualizar la dieta: $e');
      return false;
    }
  }

  String? get dietAsText {
    if (_selectedDiet == null) return null;
    switch (_selectedDiet!) {
      case DietType.estandar:
        return 'Estandar';
      case DietType.vegetariana:
        return 'Vegetariano';
    }
  }
}
