import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/home_page.dart';
import 'package:tudespensa/pages/wellcome_page.dart';
import 'package:tudespensa/provider/auth_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/pages/login_request_page.dart';
import 'package:tudespensa/pages/premium_page.dart';
import 'package:tudespensa/pages/buy_premium_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.green[700], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'ID del usuario',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user?.id ?? '-',
                        style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blue[700], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'E-mail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user?.email ?? '-',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(Icons.workspace_premium, color: Colors.amber[800], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Suscripción',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (user?.plan.toLowerCase() == 'premium' || user?.role.toLowerCase() == 'premium')
                          ? 'Premium'
                          : 'Gratuito',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if ((user?.plan.toLowerCase() ?? '') == 'gratuito')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PremiumPage()),
                      );
                    },
                    icon: Icon(Icons.workspace_premium, color: Colors.white),
                    label: Text('Conviértete a Premium', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                )
              else if ((user?.plan.toLowerCase() ?? '') == 'premium')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final option = await showModalBottomSheet<String>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.swap_horiz, color: Colors.amber[800]),
                              title: Text('Cambiar plan'),
                              onTap: () => Navigator.pop(context, 'cambiar'),
                            ),
                            ListTile(
                              leading: Icon(Icons.cancel, color: Colors.red[700]),
                              title: Text('Cancelar suscripción'),
                              onTap: () => Navigator.pop(context, 'cancelar'),
                            ),
                          ],
                        ),
                      );
                      if (option == 'cambiar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CompraPage()),
                        );
                      } else if (option == 'cancelar') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Cancelar suscripción'),
                            content: Text('¿Estás seguro de que quieres cancelar tu suscripción premium?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Sí'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          // Llamar endpoint downgrade
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('auth_token');
                          if (token != null) {
                            final response = await http.put(
                              Uri.parse('http://192.168.1.5:4000/api/users/downgrade-plan'),
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                            );
                            if (response.statusCode == 200) {
                              await Provider.of<ProfileProvider>(context, listen: false).fetchUserProfile();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Suscripción cancelada. Ahora eres usuario gratuito.'), backgroundColor: Colors.green),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al cancelar la suscripción'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        }
                      }
                    },
                    icon: Icon(Icons.settings, color: Colors.white),
                    label: Text('Modificar Suscripción', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              // Espacio entre botones de suscripción y cerrar sesión
              if ((user?.plan.toLowerCase() ?? '') == 'gratuito' || (user?.plan.toLowerCase() ?? '') == 'premium')
                const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false).logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginRequestPage()),
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
