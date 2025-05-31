import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/provider/profile_provider.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo.png', width: 65, height: 65),
              const SizedBox(width: 10),
              const Text(
                "Tu\nDespensa",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(
              children: [
                Image.asset('assets/images/icon.png', width: 68, height: 68),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.yellow.shade100,
                      onTap: () async {
                        print('[HeaderHome] Icono tocado');
                        final profileProvider = context.read<ProfileProvider>();

                        final response =
                            await profileProvider.fetchUserProfile();
                        print('[HeaderHome] Llamando a fetchUserProfile...');

                        if (response != null) {
                          print(
                              '[HeaderHome] Perfil cargado exitosamente. Navegando a UserPage.');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserPage(),
                            ),
                          );
                        } else {
                          print('[HeaderHome] Error al cargar el perfil');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error al cargar el perfil"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
