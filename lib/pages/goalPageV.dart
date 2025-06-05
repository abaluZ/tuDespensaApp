import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/goalSelection.dart';
import 'package:tudespensa/widgets/nutrientCard.dart';

class Goalpagev extends StatelessWidget {
  const Goalpagev({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              EncabezadoConImagen(
                texto: 'Objetivo',
                rutaImagen: 'assets/images/despensaPage.png',
                colorTexto: Colors.black,
              ),
              SizedBox(height: 20),
              ObjetivoUsuario(
                onEditar: () {
                  // Acción al presionar el botón de editar
                },
              ),
              TarjetaNutrientes(),
              SizedBox(height: 20), // Agregamos espacio al final para mejor visualización
            ],
          ),
        ),
      ),
    );
  }
}
