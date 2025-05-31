import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserProfileButton extends StatelessWidget {
  final String textoIzquierdo;
  final VoidCallback onPressedIzquierdo;
  final String iconoIzquierdo;

  final String textoDerecho;
  final VoidCallback onPressedDerecho;
  final String iconoDerecho;

  const UserProfileButton({
    super.key,
    required this.textoIzquierdo,
    required this.onPressedIzquierdo,
    required this.iconoIzquierdo,
    required this.textoDerecho,
    required this.onPressedDerecho,
    required this.iconoDerecho,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          textoIzquierdo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onPressedIzquierdo,
          icon: SvgPicture.asset(
            iconoIzquierdo,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(flex: 2),
        Text(
          textoDerecho,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onPressedDerecho,
          icon: SvgPicture.asset(
            iconoDerecho,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
