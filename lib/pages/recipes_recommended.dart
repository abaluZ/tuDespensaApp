import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/recipes/recipe_card.dart';

class RecipesRecommended extends StatelessWidget {
  const RecipesRecommended({super.key});

  @override
  Widget build(BuildContext context) {
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
            RecipeCard(
              image: 'assets/images/despensaPage.png',
              title: 'Sarteada de patatas con jamon y huevo',
              calories: 406,
              duration: 25,
              difficulty: 'facil',
            )
          ],
        ),
      ),
    );
  }
}
