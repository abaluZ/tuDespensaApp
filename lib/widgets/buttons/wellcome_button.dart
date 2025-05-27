import 'package:flutter/material.dart';

class WellcomeButton extends StatelessWidget {
  const WellcomeButton({
    super.key,
    required this.title,
    required this.color,
    required this.textColor,
    required this.destination,
  });

  final String title;
  final Color color;
  final Color textColor;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: color,
        ),
        width: 140,
        height: 50,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
