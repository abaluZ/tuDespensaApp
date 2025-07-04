import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/navbar/navigation_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tudespensa/Utils/preferences.dart';
import 'package:tudespensa/pages/despensa_page.dart';

class AIRecipesPage extends StatefulWidget {
  const AIRecipesPage({super.key});

  @override
  State<AIRecipesPage> createState() => _AIRecipesPageState();
}

class _AIRecipesPageState extends State<AIRecipesPage> {
  final prefs = Preferences();
  final String baseUrl = 'http://192.168.1.5:4000/api';
  String? selectedMealType;
  bool isLoading = false;
  Map<String, dynamic>? recipeData;
  List<Map<String, dynamic>>? availableRecipes;

  @override
  void initState() {
    super.initState();
    print('AIRecipesPage iniciada');
  }

  final List<Map<String, String>> mealTypes = [
    {'value': 'desayuno', 'label': 'Desayuno'},
    {'value': 'almuerzo', 'label': 'Almuerzo'},
    {'value': 'cena', 'label': 'Cena'},
    {'value': 'postre', 'label': 'Postre'},
  ];

  String _cleanJsonString(String jsonText) {
    // Eliminar los backticks y la palabra json
    final cleanText = jsonText.replaceAll('```json\n', '').replaceAll('```', '');
    return cleanText;
  }

  Future<void> fetchRecipe() async {
    if (selectedMealType == null) return;

    setState(() {
      isLoading = true;
      recipeData = null;
      availableRecipes = null;
    });

    try {
      final token = prefs.authToken;
      if (token == null || token.isEmpty) {
        throw Exception('No hay token de autenticación');
      }

      final url = Uri.parse('$baseUrl/recipes/recommendations?tipo_comida=$selectedMealType');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decodedData = json.decode(response.body);

      // Manejar el caso de no ingredientes disponibles
      if (response.statusCode == 400 && decodedData['message']?.contains('No hay ingredientes disponibles') == true) {
        setState(() {
          isLoading = false;
        });
        _mostrarMensajeNoIngredientes();
        return;
      }

      if (response.statusCode == 200) {
        if (decodedData['recipes'] != null && decodedData['recipes']['text'] != null) {
          final cleanJsonString = _cleanJsonString(decodedData['recipes']['text']);
          print('JSON limpio: $cleanJsonString'); // Para depuración
          
          try {
          final recipesJson = json.decode(cleanJsonString);
            print('JSON decodificado: $recipesJson'); // Para depuración
          
          if (recipesJson['recetas_con_ingredientes_disponibles'] != null) {
            final recetas = recipesJson['recetas_con_ingredientes_disponibles'];
              print('Recetas obtenidas: $recetas'); // Para depuración
            
            final List<Map<String, dynamic>> recetasLimpias = [];
            for (var receta in recetas) {
              if (receta is Map<String, dynamic>) {
                  // Asegurarse de que los ingredientes sean una lista
                  var ingredientes = receta['ingredientes'];
                  if (ingredientes != null) {
                    if (ingredientes is String) {
                      // Si es un string, convertirlo a lista
                      ingredientes = ingredientes.split(',').map((e) => e.trim()).toList();
                    } else if (ingredientes is! List) {
                      // Si no es una lista, convertirlo a lista con un solo elemento
                      ingredientes = [ingredientes.toString()];
                    }
                    receta['ingredientes'] = ingredientes;
                  } else {
                    receta['ingredientes'] = [];
                  }
                  
                  // Asegurarse de que la preparación sea una lista
                  var preparacion = receta['preparacion'];
                  if (preparacion != null) {
                    if (preparacion is String) {
                      // Si es un string, convertirlo a lista
                      preparacion = preparacion.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                    } else if (preparacion is! List) {
                      // Si no es una lista, convertirlo a lista con un solo elemento
                      preparacion = [preparacion.toString()];
                    }
                    receta['preparacion'] = preparacion;
                  } else {
                    receta['preparacion'] = [];
                  }
                  
                  recetasLimpias.add(receta);
              }
            }
              
              print('Recetas procesadas: $recetasLimpias'); // Para depuración
            
            setState(() {
              availableRecipes = recetasLimpias;
              recipeData = decodedData;
              isLoading = false;
            });
            } else {
              throw Exception('No se encontraron recetas disponibles');
            }
          } catch (e) {
            print('Error al procesar el JSON: $e');
            throw Exception('Error al procesar la respuesta: $e');
          }
        } else {
          throw Exception('Formato de respuesta inválido');
        }
      } else {
        throw Exception('Error al obtener la receta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error detallado: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener la receta: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  void _mostrarMensajeNoIngredientes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No hay ingredientes suficientes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'No se pueden generar recetas para ${_getTipoComidaText(selectedMealType!)} porque no hay suficientes ingredientes en tu despensa.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Text(
                  '¿Qué puedes hacer?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text('• Agrega más ingredientes a tu despensa', style: TextStyle(fontSize: 14)),
                Text('• Prueba con otro tipo de comida', style: TextStyle(fontSize: 14)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar el diálogo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DespensaPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Ir a mi despensa',
                        style: TextStyle(color: Verde),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTipoComidaText(String tipo) {
    switch (tipo) {
      case 'desayuno':
        return 'el desayuno';
      case 'almuerzo':
        return 'el almuerzo';
      case 'cena':
        return 'la cena';
      case 'postre':
        return 'el postre';
      default:
        return tipo;
    }
  }

  Widget _buildRecipeCard() {
    if (availableRecipes == null || availableRecipes!.isEmpty) {
      return Center(
        child: Text('No hay recetas disponibles'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: availableRecipes!.length,
      itemBuilder: (context, index) {
        final recipe = availableRecipes![index];
        final informacionNutricional = recipe['informacion_nutricional'] as Map<String, dynamic>?;
        
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['nombre'] ?? 'Sin nombre',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Verde,
                  ),
                ),
                if (recipe['tiempo_preparacion'] != null) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tiempo de preparación: ${recipe['tiempo_preparacion']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
                if (informacionNutricional != null) ...[
                  SizedBox(height: 8),
                  Text(
                    'Información Nutricional:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Calorías: ${informacionNutricional['calorias']} kcal'),
                  Text('Proteínas: ${informacionNutricional['proteinas']}g'),
                  Text('Carbohidratos: ${informacionNutricional['carbohidratos']}g'),
                  Text('Grasas: ${informacionNutricional['grasas']}g'),
                ],
                SizedBox(height: 20),
                _buildIngredientesSection(recipe['ingredientes']),
                SizedBox(height: 20),
                _buildPreparacionSection(recipe['preparacion']),
                if (recipe['beneficios'] != null) ...[
                  SizedBox(height: 20),
                  Text(
                    'Beneficios:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (recipe['beneficios'] as List).map((beneficio) => 
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $beneficio'),
                      )
                    ).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIngredientesSection(dynamic ingredientes) {
    if (ingredientes == null) return SizedBox();

    // Convertir a lista si no lo es
    List<dynamic> ingredientesList = [];
    if (ingredientes is List) {
      ingredientesList = ingredientes;
    } else if (ingredientes is Map) {
      ingredientesList = [ingredientes];
    } else if (ingredientes is String) {
      ingredientesList = ingredientes.split(RegExp(r',|\n')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    if (ingredientesList.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredientesList.map((ingrediente) {
              String textoIngrediente = '';
              
              if (ingrediente is Map) {
                // Manejar el nuevo formato de ingredientes
                final nombreIngrediente = ingrediente['ingrediente']?.toString() ?? ingrediente['nombre']?.toString() ?? '';
                final cantidad = ingrediente['cantidad']?.toString() ?? '';
                textoIngrediente = cantidad.isNotEmpty ? '$nombreIngrediente: $cantidad' : nombreIngrediente;
              } else if (ingrediente is String) {
                textoIngrediente = ingrediente;
              } else {
                textoIngrediente = ingrediente.toString();
              }

              // Si el texto es "null" o está vacío, no mostrar el ingrediente
              if (textoIngrediente == 'null' || textoIngrediente.isEmpty) {
                return SizedBox();
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '• $textoIngrediente',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              );
            }).where((widget) => widget is Padding).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPreparacionSection(List<dynamic>? pasos) {
    if (pasos == null) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preparación:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pasos.map((paso) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  paso,
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDespensa(
        backgroundColor: BackgroundColor,
        onBack: () => Navigator.pop(context),
        onAvatarTap: () {},
        logoPath: 'assets/images/logo.png',
        avatarPath: 'assets/images/icon.png',
        titleText: 'Recetas IA',
      ),
      bottomNavigationBar: NavigationNavbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '¿Qué plato del día quieres cocinar?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Verde),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMealType,
                        hint: Text(
                          'Selecciona un tipo de comida',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Verde),
                        items: mealTypes.map((type) {
                          return DropdownMenuItem(
                            value: type['value'],
                            child: Text(
                              type['label']!,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMealType = value;
                          });
                          fetchRecipe();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Verde),
                  ),
                ),
              )
            else
              _buildRecipeCard(),
          ],
        ),
      ),
    );
  }
} 