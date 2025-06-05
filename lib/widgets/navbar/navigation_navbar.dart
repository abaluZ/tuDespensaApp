import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/home_page.dart';
import 'package:tudespensa/pages/settings_page.dart';
import 'package:tudespensa/pages/shopping_page.dart';
import 'package:tudespensa/pages/favorites_page.dart';

class NavigationNavbar extends StatelessWidget {
  const NavigationNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: CardBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: 'Inicio',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.shopping_cart_rounded,
                label: 'Lista',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShoppingPage(),
                    ),
                  );
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.favorite_rounded,
                label: 'Favoritos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesPage(),
                    ),
                  );
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.settings_rounded,
                label: 'Ajustes',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AjustesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _isCurrentRoute(context, label);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? PrimaryColor : TextSecondaryColor,
                size: 24,
              ),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? PrimaryColor : TextSecondaryColor,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isCurrentRoute(BuildContext context, String label) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    switch (label.toLowerCase()) {
      case 'inicio':
        return currentRoute.isEmpty || currentRoute == '/';
      case 'lista':
        return currentRoute == '/shopping';
      case 'favoritos':
        return currentRoute == '/favorites';
      case 'ajustes':
        return currentRoute == '/settings';
      default:
        return false;
    }
  }
}
