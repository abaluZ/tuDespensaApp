import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/provider/calories_provider.dart';
import 'package:tudespensa/provider/reports_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/pages/premium_page.dart';
import 'dart:ui';

class TarjetaNutrientes extends StatelessWidget {
  const TarjetaNutrientes({super.key});

  Widget _buildNutrientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRow(String meal, String calories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            meal,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            calories,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: PrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadReport(BuildContext context) async {
    try {
      final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generando reporte...'),
          backgroundColor: Colors.blue,
        ),
      );

      final filePath = await reportsProvider.downloadReport();

      if (filePath != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte generado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        await OpenFile.open(filePath);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar el reporte: ${reportsProvider.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar el reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CaloriesProvider>(
      builder: (context, caloriesProvider, child) {
        if (caloriesProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final caloriesData = caloriesProvider.calories;
        if (caloriesData == null) {
          return Center(
            child: Text(
              'No hay datos disponibles',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Obtener el plan del usuario desde el ProfileProvider
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        final isPremium = (profileProvider.userModel?.plan.toLowerCase() == 'premium' || profileProvider.userModel?.role.toLowerCase() == 'premium');

        Widget diarioCard = Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Divider(height: 24),
                _buildNutrientRow('Calorías', '${caloriesData.caloriasDiarias} Kcal'),
                _buildNutrientRow('Carbohidratos', '${caloriesData.macronutrientes.carbohidratos} g'),
                _buildNutrientRow('Proteínas', '${caloriesData.macronutrientes.proteinas} g'),
                _buildNutrientRow('Grasas', '${caloriesData.macronutrientes.grasas} g'),
              ],
            ),
          ),
        );

        Widget distribucionCard = Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribución Calórica',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Divider(height: 24),
                _buildMealRow('Desayuno', '${caloriesData.distribucionCalorica.desayuno} Kcal'),
                _buildMealRow('Almuerzo', '${caloriesData.distribucionCalorica.almuerzo} Kcal'),
                _buildMealRow('Cena', '${caloriesData.distribucionCalorica.cena} Kcal'),
                _buildMealRow('Meriendas', '${caloriesData.distribucionCalorica.meriendas} Kcal'),
              ],
            ),
          ),
        );

        Widget buildLockedCard(Widget card) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PremiumPage()),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  card,
                  // Overlay sólido negro
                  Positioned.fill(
                    child: Container(
                      color: Colors.black, // Negro sólido, sin opacidad
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Premium',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isPremium ? diarioCard : buildLockedCard(diarioCard),
              SizedBox(height: 16),
              isPremium ? distribucionCard : buildLockedCard(distribucionCard),
              SizedBox(height: 16),
              if (isPremium)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadReport(context),
                    icon: Icon(Icons.download_rounded),
                    label: Text('Descargar Reporte PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
