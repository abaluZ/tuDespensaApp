import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/pages/user_page.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/provider/calories_provider.dart';

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
                        print('[HeaderHome] Iniciando carga de datos...');
                        final profileProvider = context.read<ProfileProvider>();
                        final caloriesProvider = context.read<CaloriesProvider>();

                        print('[HeaderHome] Cargando perfil y calorías en paralelo...');
                        final futures = await Future.wait([
                          profileProvider.fetchUserProfile(),
                          caloriesProvider.fetchCaloriesData(),
                        ]);

                        final userProfile = futures[0];
                        final caloriesData = futures[1];

                        if (userProfile != null && caloriesData != null) {
                          print('[HeaderHome] ✅ Perfil y calorías cargados exitosamente');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserPage(),
                            ),
                          );
                        } else {
                          print('[HeaderHome] ❌ Error en la carga de datos');
                          if (userProfile == null) print('[HeaderHome] - Error en perfil');
                          if (caloriesData == null) print('[HeaderHome] - Error en calorías');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error al cargar los datos del usuario"),
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
