import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/type_diet_provider.dart'; // Si tienes el enum separado

class DietButton extends StatelessWidget {
  const DietButton({
    super.key,
    required this.title,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String title;
  final Color color;
  final Color textColor;
  final IconData icon;
  final DietType value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedDiet = context.watch<TypeDietProvider>().selectedDiet;
    final isSelected = selectedDiet == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? color : Colors.grey.shade300,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        width: 160,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? textColor : Colors.black54),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? textColor : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
