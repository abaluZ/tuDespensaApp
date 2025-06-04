import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tudespensa/Models/user_model.dart';
import 'package:tudespensa/Utils/preferences.dart';

class ProfileProvider with ChangeNotifier {
  final prefs = Preferences();
  UserModel? userModel;

  bool isLoading = false;
  String? errorMessage;

  Future<UserModel?> fetchUserProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;

      if (token.isEmpty) {
        errorMessage = "Token no encontrado";
        print("Token null");
        isLoading = false;
        notifyListeners();
        return null;
      }

      final response = await http.get(

        Uri.parse('http://192.168.1.5:4000/api/profileApp'),

        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('esta es la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        print("Entrando");
        final data = json.decode(response.body);
        userModel = UserModel.fromJson(data);
        isLoading = false;
        notifyListeners();
        return userModel;
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        print("Entrando 403 o 401");
        errorMessage = "Sesión expirada o no autorizada";
        isLoading = false;
        notifyListeners();
        return null;
      } else {
        errorMessage = "Error al cargar perfil (${response.statusCode})";
        print("Entrando error perfil");
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = "Error de red o servidor";
      print("Entrando catch: $e");
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearProfile() {
    userModel = null;
    notifyListeners();
  }
}
