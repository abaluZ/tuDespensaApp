import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/settings_page.dart';
import 'package:tudespensa/pages/shopping_page.dart';

class NavigationNavbar extends StatelessWidget {
  const NavigationNavbar({super.key});

  Widget _buildIconButton(String assetPath, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Verde,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconButton('assets/icons/home.svg', () {}),
            _buildIconButton('assets/icons/carrito-compras.svg', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingPage()),
              );
            }),
            _buildIconButton('assets/icons/heart.svg', () {}),
            _buildIconButton('assets/icons/ajustes.svg', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AjustesPage()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
