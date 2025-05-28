import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/provider/gender_provider.dart';

class GenderButton extends StatelessWidget {
  const GenderButton({
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
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedGender = context.watch<GenderProvider>().typeGender;
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: isSelected ? color : Colors.grey.shade300,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        width: 140,
        height: 50,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? textColor : Colors.black54),
              SizedBox(width: 8),
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
