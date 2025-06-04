import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tudespensa/Models/ingredient.dart';

class IngredientProvider extends ChangeNotifier {
  final String baseUrl =
      'http://192.168.1.5:3000'; // Usa la dirección IP de tu máquina de desarrollo


  List<Ingredient> _ingredients = [];
  bool _isLoading = false;

  List<Ingredient> get ingredients => _ingredients;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> fetchIngredients() async {
    try {
      _setLoading(true);
      print(
          "Fetching ingredients from $baseUrl/api/ingredientes"); // Log para verificar la URL
      final res = await http.get(Uri.parse('$baseUrl/api/ingredientes'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _ingredients =
            (data as List).map((item) => Ingredient.fromMap(item)).toList();
        notifyListeners();
        _setLoading(false);
        print("Ingredients fetched successfully"); // Log de éxito
        return true;
      } else {
        _setLoading(false);
        print("Error al obtener los ingredientes: ${res.body}"); // Log de error
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print("Error en fetchIngredients: $e"); // Log de error
      return false;
    }
  }
}
