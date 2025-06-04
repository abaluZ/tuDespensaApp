import 'package:flutter/foundation.dart';
import '../Models/recipe_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Recipe> _favorites = [];

  List<Recipe> get favorites => _favorites;

  bool isFavorite(Recipe recipe) {
    return _favorites.any((favorite) => favorite.nombre == recipe.nombre);
  }

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)) {
      _favorites.removeWhere((favorite) => favorite.nombre == recipe.nombre);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
  }
} 