import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/home_page.dart';
import 'package:tudespensa/pages/wellcome_page.dart';
import 'package:tudespensa/provider/auth_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/user/profile_field_input.dart';

class CuentaPage extends StatelessWidget {
  const CuentaPage({super.key});

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
        titleText: 'Cuenta',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Card(
                  color: BackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    width: 400,
                    height: 550,
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                              return ProfielInput(
                                titulo: 'ID del usuraio',
                                contenido: profileProvider.userModel?.id ?? '',
                                cargando: profileProvider.isLoading,
                                colorFondo: Verde,
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                              return ProfielInput(
                                titulo: 'E-mail',
                                contenido:
                                    profileProvider.userModel?.email ?? '',
                                cargando: profileProvider.isLoading,
                                colorFondo: Verde,
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                              return ProfielInput(
                                titulo: 'Suscripcion',
                                contenido:
                                    profileProvider.userModel?.plan ?? '',
                                cargando: profileProvider.isLoading,
                                colorFondo: Verde,
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () async {
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              await authProvider.logout();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WellcomePage()),
                                  (route) => false,
                                );
                              }
                            },
                            child: Text(
                              'Cerrar Sesión',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ),
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
