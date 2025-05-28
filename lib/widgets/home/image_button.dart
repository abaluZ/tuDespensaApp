import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: 130,
                height: 135,
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
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
