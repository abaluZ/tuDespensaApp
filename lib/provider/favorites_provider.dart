import 'package:flutter/foundation.dart';
import '../Models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Recipe> _favorites = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  List<Recipe> get favorites => _favorites;

  bool isFavorite(Recipe recipe) {
    return _favorites.any((favorite) => favorite.nombre == recipe.nombre);
  }

  void toggleFavorite(Recipe recipe) async {
    if (isFavorite(recipe)) {
      _favorites.removeWhere((favorite) => favorite.nombre == recipe.nombre);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final names = _favorites.map((r) => r.nombre).toList();
    await prefs.setStringList('favorite_recipes', names);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList('favorite_recipes') ?? [];
    // Solo guardamos el nombre, así que al cargar solo tenemos el nombre
    // Puedes mejorar esto guardando más info si lo deseas
    _favorites.clear();
    for (final name in names) {
      _favorites.add(Recipe(nombre: name, descripcion: '', calorias: 0, tiempo: '-', dificultad: '', categoria: '', ingredientes: [], pasos: [], imagen: 'assets/images/recetas/default_recipe.png'));
    }
    notifyListeners();
  }
} 