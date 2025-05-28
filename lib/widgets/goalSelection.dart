import 'package:flutter/material.dart';

class ObjetivoUsuario extends StatelessWidget {
  final String objetivo;
  final VoidCallback onEditar;

  const ObjetivoUsuario({
    Key? key,
    required this.objetivo,
    required this.onEditar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Tu objetivo es',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              objetivo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEditar,
              tooltip: 'Editar objetivo',
            ),
          ],
        ),
      ],
    );
  }
}
