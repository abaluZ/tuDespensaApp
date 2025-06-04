import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/provider/calories_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/information/banner_page.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/information/goalSelection.dart';
import 'package:tudespensa/widgets/nutrientCard.dart';
import 'package:tudespensa/provider/reports_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class Goalpagev extends StatefulWidget {
  const Goalpagev({super.key});

  @override
  State<Goalpagev> createState() => _GoalpageState();
}

class _GoalpageState extends State<Goalpagev> {
  @override
  void initState() {
    super.initState();
    // Cargar los datos cuando se inicia la página
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = context.read<ProfileProvider>();
      final caloriesProvider = context.read<CaloriesProvider>();

      // Cargar perfil y calorías en paralelo
      await Future.wait([
        profileProvider.fetchUserProfile(),
        caloriesProvider.fetchCaloriesData(),
      ]);

      if (mounted) {
        final plan = profileProvider.userModel?.plan;
        print('[Goalpagev] Plan del usuario: $plan');
      }
    });
  }

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
            Consumer2<ProfileProvider, CaloriesProvider>(
              builder: (context, profileProvider, caloriesProvider, child) {
                if (profileProvider.isLoading || caloriesProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (profileProvider.userModel == null) {
                  return const Center(
                    child: Text('Error al cargar el perfil'),
                  );
                }
                return TarjetaNutrientes();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<ReportsProvider>(
                builder: (context, reportsProvider, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Verde,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: reportsProvider.isLoading
                        ? null
                        : () async {
                            final filePath =
                                await reportsProvider.downloadReport();
                            if (filePath != null) {
                              final file = File(filePath);
                              if (await file.exists()) {
                                try {
                                  final result = await OpenFile.open(
                                    filePath,
                                    type: 'application/pdf',
                                  );
                                  if (result.type != ResultType.done) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Por favor instala una aplicación para ver PDFs"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Error al abrir el PDF"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("El archivo no existe"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        reportsProvider.errorMessage ??
                                            "Error al descargar el reporte"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          reportsProvider.isLoading
                              ? "Descargando..."
                              : "Descargar Reporte PDF",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
