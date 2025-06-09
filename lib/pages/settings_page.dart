import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/icon_personalizado.dart';
import 'package:tudespensa/pages/home_page.dart';
import 'package:tudespensa/pages/premium_page.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/pages/account_page.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/pages/goalPageV.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tudespensa/widgets/navbar/navigation_navbar.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? PrimaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? PrimaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDespensa(
        backgroundColor: BackgroundColor,
        onBack: () {
          Navigator.pop(context);
        },
        onAvatarTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        },
        logoPath: 'assets/images/logo.png',
        avatarPath: 'assets/images/icon.png',
        titleText: 'Ajustes',
      ),
      bottomNavigationBar: NavigationNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Configuración',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildSettingsCard(
              title: 'Cuenta',
              icon: Icons.account_circle_rounded,
              iconColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
              },
            ),
            _buildSettingsCard(
              title: 'Perfil',
              icon: Icons.person_rounded,
              iconColor: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPage(),
                  ),
                );
              },
            ),
            _buildSettingsCard(
              title: 'Mi Objetivo',
              icon: Icons.track_changes_rounded,
              iconColor: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Goalpagev(),
                  ),
                );
              },
            ),
            _buildSettingsCard(
              title: 'Premium',
              icon: Icons.star_rounded,
              iconColor: Colors.amber,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PremiumPage(),
                  ),
                );
              },
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.amber[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Más información',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildSettingsCard(
              title: 'Sitio Web',
              icon: Icons.language_rounded,
              iconColor: Colors.purple,
              onTap: () async {
                final Uri url = Uri.parse('https://tudespensa.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            _buildSettingsCard(
              title: 'Página de la Empresa',
              icon: Icons.business_rounded,
              iconColor: Colors.indigo,
              onTap: () async {
                try {
                  await _launchURL('https://los-kollingas.netlify.app/');
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No se pudo abrir la página: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            _buildSettingsCard(
              title: 'Términos y condiciones',
              icon: Icons.description_rounded,
              iconColor: Colors.purple,
              onTap: () {
                // TODO: Implementar navegación a términos y condiciones
              },
            ),
            _buildSettingsCard(
              title: 'Política de privacidad',
              icon: Icons.privacy_tip_rounded,
              iconColor: Colors.indigo,
              onTap: () {
                // TODO: Implementar navegación a política de privacidad
              },
            ),
          ],
        ),
      ),
    );
  }
}
