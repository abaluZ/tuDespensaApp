import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favorites_provider.dart';
import '../widgets/recipes/recipe_card.dart';
import 'recipe_detail_page.dart';
import '../Models/recipe_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas Favoritas'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No tienes recetas favoritas aún.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}