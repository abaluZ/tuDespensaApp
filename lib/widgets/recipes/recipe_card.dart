import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final int calories;
  final int duration;
  final String difficulty;

  const RecipeCard({
    super.key,
    required this.image,
    required this.title,
    required this.calories,
    required this.duration,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF), // fondo celeste claro
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // Contenido a la derecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 18),
                      const SizedBox(width: 4),
                      Text('$calories kcal'),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer, size: 18),
                      const SizedBox(width: 4),
                      Text('$duration min'),
                      const SizedBox(width: 12),
                      const Icon(Icons.restaurant_menu, size: 18),
                      const SizedBox(width: 4),
                      Text(difficulty),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Acción de ver receta
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Ver receta"),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_circle_right, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
