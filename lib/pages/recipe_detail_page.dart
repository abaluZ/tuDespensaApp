import 'package:flutter/material.dart';
import 'package:tudespensa/Models/recipe_model.dart'; // Asegúrate de importar tu modelo de receta

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del Plato
            Image.asset(
              recipe.imagen,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            const SizedBox(height: 16),

            // Título del Plato
            Text(
              recipe.nombre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Iconos de Información Rápida
            Row(
              children: [
                IconTextInfo(
                    icon: Icons.local_fire_department,
                    text: '${recipe.calorias} kcal'),
                const SizedBox(width: 16),
                IconTextInfo(icon: Icons.timer, text: '${recipe.tiempo} min'),
                const SizedBox(width: 16),
                IconTextInfo(
                    icon: Icons.restaurant_menu, text: recipe.dificultad),
              ],
            ),
            const SizedBox(height: 16),

            // Descripción del Plato
            Text(
              recipe.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Etiquetas/Categorías
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (var tag in recipe.categoria.split(', '))
                  Chip(label: Text(tag)),
              ],
            ),
            const SizedBox(height: 16),

            // Sección de Contenido Premium
            Column(
              children: [
                const Text(
                  'Para acceder a cientos de deliciosas recetas, debes ser un usuario PREMIUM!',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navegar a la página de suscripción premium
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text('Premium'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sección de Ingredientes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingredientes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Estos son los ingredientes que debes tener.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                for (var ingrediente in recipe.ingredientes)
                  ListTile(
                    leading: const Icon(Icons.check),
                    title: Text(ingrediente),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Sección de Pasos de Preparación
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pasos de Preparación',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (var paso in recipe.pasos)
                  ListTile(
                    leading: CircleAvatar(
                        child: Text('${recipe.pasos.indexOf(paso) + 1}')),
                    title: Text(paso),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconTextInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconTextInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
