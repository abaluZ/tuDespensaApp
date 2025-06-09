import 'package:flutter/material.dart';
import 'package:tudespensa/pages/recipe_detail_page.dart';
import 'package:tudespensa/Utils/preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tudespensa/Models/recipe_model.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/pages/premium_page.dart';
import '../provider/favorites_provider.dart';

class AIRecipesHistoryPage extends StatefulWidget {
  const AIRecipesHistoryPage({super.key});

  @override
  State<AIRecipesHistoryPage> createState() => _AIRecipesHistoryPageState();
}

class _AIRecipesHistoryPageState extends State<AIRecipesHistoryPage> {
  final prefs = Preferences();
  final String baseUrl = 'http://192.168.1.5:4000/api';
  String selectedMealType = 'desayuno';
  Map<String, List<dynamic>> historial = {
    'desayuno': [],
    'almuerzo': [],
    'cena': [],
    'postre': [],
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() => isLoading = true);
    try {
      final token = prefs.authToken;
      final url = Uri.parse('$baseUrl/recipes/history');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          historial = Map<String, List<dynamic>>.from(
            decoded['historial'].map((k, v) => MapEntry(k, List<dynamic>.from(v)))
          );
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el historial')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recetas = historial[selectedMealType] ?? [];
    // Obtengo el estado premium del usuario
    final profileProvider = Provider.of<ProfileProvider>(context, listen: true);
    final isPremium = (profileProvider.userModel?.plan?.toLowerCase() == 'premium' || profileProvider.userModel?.role?.toLowerCase() == 'premium');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Recetas IA'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMealTypeButton('desayuno', 'Desayuno'),
                const SizedBox(width: 8),
                _buildMealTypeButton('almuerzo', 'Almuerzo'),
                const SizedBox(width: 8),
                _buildMealTypeButton('cena', 'Cena'),
                const SizedBox(width: 8),
                _buildMealTypeButton('postre', 'Postre'),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : recetas.isEmpty
                    ? const Center(child: Text('No hay recetas en el historial'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: recetas.length,
                        itemBuilder: (context, index) {
                          final receta = recetas[index];
                          final nombre = receta['nombre'] ?? 'Sin nombre';
                          final infoNutri = receta['informacion_nutricional'] ?? {};
                          final calorias = infoNutri['calorias']?.toString() ?? '-';
                          final tiempo = receta['tiempo_preparacion'] ?? '-';
                          final imagen = 'assets/images/recetas/default_recipe.png';
                          return Stack(
                            children: [
                              Card(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                      child: Image.asset(
                                        imagen,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    nombre,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Consumer<FavoritesProvider>(
                                                  builder: (context, favoritesProvider, _) {
                                                    final recipeModel = _convertToRecipeModel(receta);
                                                    final isFavorite = favoritesProvider.isFavorite(recipeModel);
                                                    return IconButton(
                                                      icon: Icon(
                                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                                        color: isFavorite ? Colors.red : Colors.grey,
                                                        size: 22,
                                                      ),
                                                      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        favoritesProvider.toggleFavorite(recipeModel);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    '$calorias kcal (aproximadamente)',
                                                    style: const TextStyle(fontSize: 14),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.timer, color: Colors.black54, size: 18),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    '$tiempo',
                                                    style: const TextStyle(fontSize: 14),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: isPremium
                                                  ? TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => RecipeDetailPage(
                                                              recipe: _convertToRecipeModel(receta),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text('Ver receta'),
                                                    )
                                                  : Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                                                      decoration: BoxDecoration(
                                                        color: Colors.purple[50],
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons.lock, color: Colors.purple, size: 18),
                                                          SizedBox(width: 6),
                                                          Text('Premium', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isPremium)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.80),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.lock, color: Colors.purple, size: 36),
                                          SizedBox(height: 8),
                                          Text('Solo para usuarios Premium', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purple,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PremiumPage()),
                                              );
                                            },
                                            icon: Icon(Icons.star),
                                            label: Text('Hazte Premium'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeButton(String value, String label) {
    final isSelected = selectedMealType == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedMealType = value;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(label),
      ),
    );
  }

  // Convierte el mapa de receta del historial a un modelo compatible con RecipeDetailPage
  Recipe _convertToRecipeModel(Map<String, dynamic> receta) {
    return Recipe(
      nombre: receta['nombre'] ?? '',
      descripcion: '',
      calorias: int.tryParse(receta['informacion_nutricional']?['calorias']?.toString() ?? '0') ?? 0,
      tiempo: receta['tiempo_preparacion'] ?? '-',
      dificultad: '',
      categoria: selectedMealType,
      ingredientes: (receta['ingredientes'] ?? receta['ingredientes_disponibles'] ?? []).map<String>((e) {
        if (e is Map && e['ingrediente'] != null && e['cantidad'] != null) {
          return '${e['ingrediente'] ?? e['nombre']}: ${e['cantidad']}';
        } else if (e is Map && e['nombre'] != null && e['cantidad'] != null) {
          return '${e['nombre']}: ${e['cantidad']}';
        } else if (e is String) {
          return e;
        } else {
          return e.toString();
        }
      }).toList(),
      pasos: (receta['preparacion'] ?? []).map<String>((e) => e.toString()).toList(),
      imagen: 'assets/images/recetas/default_recipe.png',
    );
  }
} 