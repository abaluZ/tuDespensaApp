import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/calories_provider.dart';
import '../Models/recipe_model.dart';
import '../Data/recetas_list.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/pages/recipe_detail_page.dart';
import 'package:tudespensa/widgets/recipes/recipe_card.dart';

class RecipesRecommended extends StatefulWidget {
  const RecipesRecommended({super.key});

  @override
  State<RecipesRecommended> createState() => _RecipesRecommendedState();
}

class _RecipesRecommendedState extends State<RecipesRecommended> {
  String _selectedMealType = 'Desayuno';
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final caloriesProvider = Provider.of<CaloriesProvider>(context, listen: false);
      await caloriesProvider.fetchCalories();
      _filterRecipes();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterRecipes() {
    final List<Recipe> allRecipes = recipes.map((recipeMap) => Recipe.fromJson(recipeMap)).toList();
    
    setState(() {
      _filteredRecipes = allRecipes.where((recipe) => recipe.categoria == _selectedMealType).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final caloriesProvider = Provider.of<CaloriesProvider>(context);
    final calories = caloriesProvider.calories;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (calories == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No se pudieron cargar los datos de calorías'),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calorías recomendadas por comida:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Desayuno: ${calories.desayuno} kcal'),
                Text('Almuerzo: ${calories.almuerzo} kcal'),
                Text('Cena: ${calories.cena} kcal'),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildMealTypeButton('Desayuno'),
                const SizedBox(width: 8),
                _buildMealTypeButton('Almuerzo'),
                const SizedBox(width: 8),
                _buildMealTypeButton('Cena'),
              ],
            ),
          ),
          Expanded(
            child: _filteredRecipes.isEmpty
                ? const Center(
                    child: Text('No hay recetas disponibles para esta categoría'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      return RecipeCard(
                        image: recipe.imagen,
                        title: recipe.nombre,
                        calories: recipe.calorias,
                        duration: int.tryParse(recipe.tiempo.replaceAll(' min', '')) ?? 0,
                        difficulty: recipe.dificultad,
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
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeButton(String mealType) {
    final isSelected = _selectedMealType == mealType;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedMealType = mealType;
          _filterRecipes();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(mealType),
    );
  }
}
