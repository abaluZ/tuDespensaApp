import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/despensa_page.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/home/header_home.dart';
import 'package:tudespensa/widgets/home/image_button.dart';
import 'package:tudespensa/widgets/home/navigation_navbar.dart';
import 'package:tudespensa/widgets/home/recommended_recipes_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

            // Recetas recomendadas
            RecetasRecomendadasButton(
              onTap: () {
                // Aquí pones la acción deseada
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
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Goalpagev()),
                  );
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
