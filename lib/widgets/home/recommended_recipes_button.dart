import 'package:flutter/material.dart';

class RecetasRecomendadasButton extends StatelessWidget {
  final VoidCallback onTap;

  const RecetasRecomendadasButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Recetas Recomendadas",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/recetasReom.png',
                width: 228,
                height: 85,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.yellow.shade100,
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
