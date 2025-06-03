import 'package:flutter/material.dart';
import 'package:tudespensa/Data/recetas_list.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/recipes/recipe_card.dart';
import 'package:tudespensa/Models/recipe_model.dart'; // Asegúrate de importar tu modelo de receta
import 'package:tudespensa/pages/recipe_detail_page.dart'; // Asegúrate de importar la nueva página de detalle de la receta

class RecipesRecommended extends StatelessWidget {
  const RecipesRecommended({super.key});

  @override
  Widget build(BuildContext context) {
    // Convertir la lista de mapas a una lista de objetos Recipe
    List<Recipe> recipesList =
        recipes.map((recipe) => Recipe.fromJson(recipe)).toList();

    // Imprimir todas las recetas en la consola
    print('Todas las recetas:');
    for (var recipe in recipesList) {
      print(
          'Nombre: ${recipe.nombre}, Categoría: ${recipe.categoria}, Calorías: ${recipe.calorias}');
    }

    return Scaffold(
      appBar: AppBarDespensa(
        backgroundColor: BackgroundColor,
        onBack: () {
          Navigator.pop(context);
        },
        onAvatarTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(),
            ),
          );
        },
        logoPath: 'assets/images/logo.png',
        avatarPath: 'assets/images/icon.png',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EncabezadoConImagen(
              texto: 'Objetivo',
              rutaImagen: 'assets/images/despensaPage.png',
              colorTexto: Colors.black,
            ),
            SizedBox(height: 25),
            ...recipesList
                .map((recipe) => RecipeCard(
                      image: recipe.imagen,
                      title: recipe.nombre,
                      calories: recipe.calorias,
                      duration:
                          int.tryParse(recipe.tiempo.replaceAll(' min', '')) ??
                              0,
                      difficulty: recipe.dificultad,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailPage(recipe: recipe),
                          ),
                        );
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
