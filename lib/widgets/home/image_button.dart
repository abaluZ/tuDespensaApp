import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';

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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 130,
          height: 135,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: label == 'Objetivo' ? PrimaryGradient : SecondaryGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Icono de respaldo según el tipo de botón
                      IconData fallbackIcon;
                      switch (label.toLowerCase()) {
                        case 'objetivo':
                          fallbackIcon = Icons.track_changes_rounded;
                          break;
                        case 'recetas ia':
                          fallbackIcon = Icons.restaurant_menu_rounded;
                          break;
                        case 'mi despensa':
                          fallbackIcon = Icons.kitchen_rounded;
                          break;
                        case 'historial':
                          fallbackIcon = Icons.history_rounded;
                          break;
                        default:
                          fallbackIcon = Icons.image_not_supported_rounded;
                      }
                      return Icon(
                        fallbackIcon,
                        size: 40,
                        color: label == 'Objetivo' ? PrimaryColor : SecondaryColor,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
