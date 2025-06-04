import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utils/preferences.dart';

class ApiService {
  static final String baseUrl = 'http://192.168.0.57:4000/api';
  static final prefs = Preferences();

  static Future<Map<String, dynamic>> getCalories() async {
    final token = prefs.authToken;
    if (token.isEmpty) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/calorias'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    } else {
      throw Exception('Error del servidor (${response.statusCode})');
    }
  }
} 