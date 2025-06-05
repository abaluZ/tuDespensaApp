import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/despensa_page.dart';
import 'package:tudespensa/pages/goalPageV.dart';
import 'package:tudespensa/pages/recipes_recommended.dart';
import 'package:tudespensa/pages/ai_recipes_page.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCaloriesData();
    });
  }

  Future<void> _loadCaloriesData() async {
    try {
      final caloriesProvider =
          Provider.of<CaloriesProvider>(context, listen: false);
      await caloriesProvider.fetchCaloriesData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al cargar los datos iniciales: ${e.toString()}',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: ErrorColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationNavbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [BackgroundColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                HeaderHome(),

                // Saludo con username desde ProfileProvider
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      if (profileProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenido,',
                              style: TextStyle(
                                color: TextSecondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${profileProvider.userModel?.username}',
                              style: TextStyle(
                                color: PrimaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),

                // Estado de calorías
                Consumer<CaloriesProvider>(
                  builder: (context, caloriesProvider, child) {
                    if (caloriesProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (caloriesProvider.errorMessage != null) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ErrorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Error: ${caloriesProvider.errorMessage}',
                          style: TextStyle(color: ErrorColor),
                        ),
                      );
                    } else if (caloriesProvider.caloriesModel != null) {
                      return const SizedBox.shrink();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                const SizedBox(height: 24),

                // Recetas recomendadas con nuevo diseño
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: RecetasRecomendadasButton(
                    onTap: () async {
                      try {
                        final caloriesProvider =
                            Provider.of<CaloriesProvider>(context, listen: false);
                        
                        setState(() => _isLoading = true);
                        
                        if (caloriesProvider.caloriesModel == null) {
                          await caloriesProvider.fetchCaloriesData();
                        }

                        if (!mounted) return;
                        setState(() => _isLoading = false);

                        if (caloriesProvider.caloriesModel != null) {
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecipesRecommended(),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No se pudieron cargar los datos de calorías. Por favor, intenta nuevamente.',
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: ErrorColor,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        setState(() => _isLoading = false);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error al cargar los datos: ${e.toString()}',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: ErrorColor,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                ),

                // Grid de botones principales con nuevo diseño
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      'Objetivo',
                      'assets/images/objetivoButton.png',
                      () async {
                        final caloriesProvider = context.read<CaloriesProvider>();
                        await caloriesProvider.fetchCaloriesData();
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Goalpagev(),
                            ),
                          );
                        }
                      },
                    ),
                    _buildFeatureCard(
                      'Recetas IA',
                      'assets/images/recetasButton.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AIRecipesPage(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      'Mi Despensa',
                      'assets/images/despensabutton.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DespensaPage(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      'Historial',
                      'assets/images/historialButton.png',
                      () {
                        // TODO: Implementar navegación al historial
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String imagePath, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: title == 'Objetivo' ? PrimaryGradient : SecondaryGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
