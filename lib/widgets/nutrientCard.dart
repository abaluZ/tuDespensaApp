import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diario',
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
                    _formatoLinea('Calorías', '1971 Kcal'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatoLinea('Carbohidratos', '240 g'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatoLinea('Proteínas', '96 g'),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatoLinea('Grasas', '64 g'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
