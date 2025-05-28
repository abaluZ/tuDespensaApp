import 'package:flutter/material.dart';

class EncabezadoConImagen extends StatelessWidget {
  final String texto;
  final String rutaImagen;
  final Color colorTexto;

  const EncabezadoConImagen({
    Key? key,
    required this.texto,
    required this.rutaImagen,
    required this.colorTexto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              texto,
              style: TextStyle(
                fontSize: 30,
                color: colorTexto,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            rutaImagen,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
