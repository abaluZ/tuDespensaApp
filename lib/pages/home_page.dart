import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/despensa_page.dart';
import 'package:tudespensa/pages/goalPageV.dart';
import 'package:tudespensa/pages/recipes_recommended.dart';
import 'package:tudespensa/provider/calories_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/home/header_home.dart';
import 'package:tudespensa/widgets/home/image_button.dart';
import 'package:tudespensa/widgets/navbar/navigation_navbar.dart';
import 'package:tudespensa/widgets/home/recommended_recipes_button.dart';
import 'package:tudespensa/provider/calories_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadCaloriesData();
  }

  Future<void> _loadCaloriesData() async {
    final caloriesProvider =
        Provider.of<CaloriesProvider>(context, listen: false);
    await caloriesProvider.fetchCaloriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            HeaderHome(),

            // Saludo con username desde ProfileProvider
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  if (profileProvider.isLoading) {
                    return const Text('Cargando...');
                  } else {
                    return Text(
                      'Bienvenido,  ${profileProvider.userModel?.username}',
                      style: TextStyle(color: Naranja, fontSize: 30),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            // Mostrar mensaje de carga o error
            Consumer<CaloriesProvider>(
              builder: (context, caloriesProvider, child) {
                if (caloriesProvider.isLoading) {
                  return const CircularProgressIndicator();
                } else if (caloriesProvider.errorMessage != null) {
                  return Text(
                    'Error: ${caloriesProvider.errorMessage}',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (caloriesProvider.caloriesModel != null) {
                  // Imprime la información relevante en la consola
                  print(
                      'Desayuno: ${caloriesProvider.caloriesModel!.data.distribucionCalorica.desayuno} kcal');
                  print(
                      'Almuerzo: ${caloriesProvider.caloriesModel!.data.distribucionCalorica.almuerzo} kcal');
                  print(
                      'Cena: ${caloriesProvider.caloriesModel!.data.distribucionCalorica.cena} kcal');

                  return Text(
                    'Calorías cargadas exitosamente',
                    style: TextStyle(color: Colors.green),
                  );
                } else {
                  return const Text('No hay datos de calorías disponibles');
                }
              },
            ),

            const SizedBox(height: 25),

            // Recetas recomendadas
            RecetasRecomendadasButton(
              onTap: () async {
                // Obtener el provider
                final caloriesProvider =
                    Provider.of<CaloriesProvider>(context, listen: false);

                // Imprimir en consola antes de navegar
                print('Navegando a Recetas Recomendadas');
                print('Datos de calorías: ${caloriesProvider.caloriesModel}');

                if (caloriesProvider.caloriesModel != null) {
                  // Definir los tipos de comidas y el máximo de calorías
                  final mealTypes = ['desayuno', 'almuerzo', 'cena'];
                  final maxCalories =
                      caloriesProvider.caloriesModel!.data.caloriasDiarias;

                  // Navegar a la página RecipesRecommended con los argumentos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipesRecommended(),
                    ),
                  );
                } else {
                  // Manejar el caso en el que no se puedan obtener los datos
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'No se pudieron obtener los datos de calorías.')),
                  );
                }
              },
            ),

            const SizedBox(height: 25),

            // Botones principales 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageButton(
                  imagePath: 'assets/images/objetivoButton.png',
                  label: 'Objetivo',
                  onTap: () async {
                    final caloriesProvider = context.read<CaloriesProvider>();
                    await caloriesProvider.fetchCaloriesData();
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Goalpagev()),
                      );
                    }
                  },
                ),
                const SizedBox(width: 15),
                ImageButton(
                  imagePath: 'assets/images/recetasButton.png',
                  label: 'Recetas IA',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Botones principales 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageButton(
                  imagePath: 'assets/images/despensabutton.png',
                  label: 'Despensa',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DespensaPage()),
                    );
                  },
                ),
                const SizedBox(width: 15),
                ImageButton(
                  imagePath: 'assets/images/historialButton.png',
                  label: 'Historial',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
