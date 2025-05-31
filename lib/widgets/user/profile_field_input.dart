import 'package:flutter/material.dart';

class ProfielInput extends StatelessWidget {
  final String titulo;
  final String contenido;
  final bool cargando;
  final Color colorFondo;

  const ProfielInput({
    super.key,
    required this.titulo,
    required this.contenido,
    required this.cargando,
    required this.colorFondo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: colorFondo,
            borderRadius: BorderRadius.circular(15),
          ),
          child: cargando
              ? const Text(
                  'Cargando...',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              : Text(
                  contenido,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
        ),
      ],
    );
  }
}
