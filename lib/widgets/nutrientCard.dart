import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/calories_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';

class TarjetaNutrientes extends StatelessWidget {
  const TarjetaNutrientes({Key? key}) : super(key: key);

  String _formatoLinea(String titulo, String valor) {
    const int totalLength = 40;
    String puntos = '.';
    int puntosNecesarios = totalLength - titulo.length - valor.length;
    if (puntosNecesarios < 0) puntosNecesarios = 3;

    puntos = List.filled(puntosNecesarios, '.').join();
    return '$titulo$puntos$valor';
  }

  Widget _buildPremiumOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              'Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final caloriesProvider = context.watch<CaloriesProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    print(
        '[TarjetaNutrientes] Plan del usuario: ${profileProvider.userModel?.plan}');
    final isPremium =
        profileProvider.userModel?.plan?.toLowerCase() == 'premium';
    print('[TarjetaNutrientes] ¿Es usuario premium?: $isPremium');

    final calorias = caloriesProvider.caloriesModel?.data.caloriasDiarias ?? 0;
    final carbohidratos =
        caloriesProvider.caloriesModel?.data.macronutrientes.carbohidratos ?? 0;
    final proteinas =
        caloriesProvider.caloriesModel?.data.macronutrientes.proteinas ?? 0;
    final grasas =
        caloriesProvider.caloriesModel?.data.macronutrientes.grasas ?? 0;

    print('[TarjetaNutrientes] Mostrando datos:');
    print('- Calorías: $calorias');
    print('- Carbohidratos: $carbohidratos');
    print('- Proteínas: $proteinas');
    print('- Grasas: $grasas');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Diario',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isPremium) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatoLinea('Calorías', '$calorias Kcal'),
                        style: TextStyle(
                          fontSize: 16,
                          color: isPremium ? Colors.black : Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatoLinea('Carbohidratos', '$carbohidratos g'),
                        style: TextStyle(
                          fontSize: 16,
                          color: isPremium ? Colors.black : Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatoLinea('Proteínas', '$proteinas g'),
                        style: TextStyle(
                          fontSize: 16,
                          color: isPremium ? Colors.black : Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatoLinea('Grasas', '$grasas g'),
                        style: TextStyle(
                          fontSize: 16,
                          color: isPremium ? Colors.black : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isPremium)
                Positioned.fill(
                  child: _buildPremiumOverlay(),
                ),
            ],
          ),
          if (isPremium) ...[
            const SizedBox(height: 16),
            const Text(
              'Distribución Calórica',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatoLinea('Desayuno',
                          '${caloriesProvider.caloriesModel?.data.distribucionCalorica.desayuno ?? 0} Kcal'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatoLinea('Almuerzo',
                          '${caloriesProvider.caloriesModel?.data.distribucionCalorica.almuerzo ?? 0} Kcal'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatoLinea('Cena',
                          '${caloriesProvider.caloriesModel?.data.distribucionCalorica.cena ?? 0} Kcal'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatoLinea('Meriendas',
                          '${caloriesProvider.caloriesModel?.data.distribucionCalorica.meriendas ?? 0} Kcal'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
