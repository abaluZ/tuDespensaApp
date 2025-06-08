import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tudespensa/Models/shopping_item.dart';
import 'auth_provider.dart'; // Asegúrate de importar AuthProvider

class DespensaUserProvider extends ChangeNotifier {
  final String baseUrl =
      'http://192.168.1.4:4000/api'; // ajusta si usas IP local o deploy

  List<ShoppingItem> _shoppingItems = [];
  bool _isLoading = false;

  List<ShoppingItem> get shoppingItems => _shoppingItems;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> saveOrUpdateDespensaList(BuildContext context) async {
    try {
      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();

      if (token == null) {
        print("Token no encontrado");
        _setLoading(false);
        return false;
      }

      final res = await http.post(
        Uri.parse('$baseUrl/despensa-list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            {'items': _shoppingItems.map((item) => item.toMap()).toList()}),
      );

      _setLoading(false);

      if (res.statusCode == 200) {
        print("Lista de despensa guardada/actualizada correctamente");
        return true;
      } else {
        print("Error al guardar/actualizar la lista de despensa: ${res.body}");
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print("Error en saveOrUpdateDespensaList: $e");
      return false;
    }
  }

  Future<bool> fetchDespensaList(BuildContext context) async {
    try {
      final token =
          await Provider.of<AuthProvider>(context, listen: false).getToken();

      if (token == null) {
        print("Token no encontrado");
        _setLoading(false);
        return false;
      }

      final res = await http.get(
        Uri.parse('$baseUrl/despensa-list'),
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
        print("Lista de despensa obtenida correctamente");
        return true;
      } else {
        print("Error al obtener la lista de despensa: ${res.body}");
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print("Error en fetchDespensaList: $e");
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
}
