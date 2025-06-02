import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar Provider
import 'package:tudespensa/provider/type_diet_provider.dart';
import 'package:tudespensa/widgets/buttons/diet_button.dart';
import 'package:tudespensa/widgets/information/information_banner.dart'; // Importar el banner de información
import 'package:tudespensa/widgets/logo_empresa.dart'; // Importar el widget del logo

class SpecificDiet extends StatelessWidget {
  const SpecificDiet({super.key});

  @override
  Widget build(BuildContext context) {
    //final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Widget para el banner
            InformationBanner(),
            SizedBox(height: 30),
            // Sección de objetivo
            Text(
              "Dieta",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "¿Sigues una dieta específica?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            // Widget para los botones de selección
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DietButton(
                  title: 'Clásica',
                  icon: Icons.restaurant,
                  color: Colors.green,
                  textColor: Colors.white,
                  value: DietType.clasica,
                  onTap: () {
                    context
                        .read<TypeDietProvider>()
                        .changeDiet(DietType.clasica);
                  },
                ),
                SizedBox(height: 20),
                DietButton(
                  title: 'Pescariana',
                  icon: Icons.restaurant,
                  color: Colors.green,
                  textColor: Colors.white,
                  value: DietType.clasica,
                  onTap: () {
                    context
                        .read<TypeDietProvider>()
                        .changeDiet(DietType.pescariana);
                  },
                ),
                SizedBox(height: 20),
                DietButton(
                  title: 'Vegetariana',
                  icon: Icons.restaurant,
                  color: Colors.green,
                  textColor: Colors.white,
                  value: DietType.clasica,
                  onTap: () {
                    context
                        .read<TypeDietProvider>()
                        .changeDiet(DietType.vegetariana);
                  },
                ),
                SizedBox(height: 20),
                DietButton(
                  title: 'Vegana',
                  icon: Icons.restaurant,
                  color: Colors.green,
                  textColor: Colors.white,
                  value: DietType.clasica,
                  onTap: () {
                    context
                        .read<TypeDietProvider>()
                        .changeDiet(DietType.vegana);
                  },
                ),
              ],
            ),

            SizedBox(height: 30),
            // Widget para el botón de continuar
            LogoEmpresa(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
