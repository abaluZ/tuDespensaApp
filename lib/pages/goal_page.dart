import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar Provider
import 'package:tudespensa/pages/information_page.dart'; // Importar la página a la que se navegará
import 'package:tudespensa/widgets/buttons/goal_button.dart'; // Importar el boton de objetivo
import 'package:tudespensa/widgets/buttons/selection_button.dart'; // Importar los botones de selección
import 'package:tudespensa/provider/goal_provider.dart'; // Importar el provider de objetivo
import 'package:tudespensa/widgets/information/information_banner.dart'; // Importar el banner de información
import 'package:tudespensa/widgets/logo_empresa.dart'; // Importar el widget del logo

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

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
              "¿Cuál es tu objetivo?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            // Widget para los botones de selección
            SelectionButton(),
            SizedBox(height: 30),
            // Widget para el botón de continuar
            GoalButton(
              text: "Siguiente",
              nextPage: const InformationPage(),
              goalProvider: goalProvider,
              onSave: goalProvider.saveGoal,
            ),
            SizedBox(height: 30),
            // Widget para el logo de la empresa
            LogoEmpresa(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
