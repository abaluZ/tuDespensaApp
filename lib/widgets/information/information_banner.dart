import 'package:flutter/material.dart';

class InformationBanner extends StatelessWidget {
  const InformationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Tu\nDespensa",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        const SizedBox(width: 35),
        Image.asset(
          'assets/images/logo.png',
          height: 56,
          width: 56,
        ),
      ],
    );
  }
}
