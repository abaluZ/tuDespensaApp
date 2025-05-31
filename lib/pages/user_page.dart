import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/account_page.dart';
import 'package:tudespensa/pages/home_page.dart';
import 'package:tudespensa/provider/profile_provider.dart';
import 'package:tudespensa/widgets/appBarV.dart';
import 'package:tudespensa/widgets/user/profile_field_input.dart';
import 'package:tudespensa/widgets/user/update_button.dart';
import 'package:tudespensa/widgets/user/user_button.dart';
import 'package:tudespensa/widgets/user/user_profile_card.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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
        titleText: 'Perfil',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserProfileCard(),
                SizedBox(height: 20),
                Center(
                  child: Card(
                    color: BackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      width: 400,
                      height: 650,
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Nombre',
                                  contenido:
                                      profileProvider.userModel?.nombre ?? '',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Apellidos',
                                  contenido:
                                      profileProvider.userModel?.apellidos ??
                                          '',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Peso',
                                  contenido:
                                      profileProvider.userModel?.peso ?? '',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Altura',
                                  contenido:
                                      profileProvider.userModel?.estatura ?? '',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Genero',
                                  contenido:
                                      profileProvider.userModel?.genero ?? '',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Fecha de nacimiento',
                                  contenido:
                                      profileProvider.userModel?.edad ?? '',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) {
                                return ProfielInput(
                                  titulo: 'Preferencia de dieta',
                                  contenido: profileProvider.userModel?.edad ??
                                      'Introducir',
                                  cargando: profileProvider.isLoading,
                                  colorFondo: Verde,
                                );
                              },
                            ),
                            SizedBox(height: 13),
                            UserProfileButton(
                              textoIzquierdo: 'Editar',
                              iconoIzquierdo: 'assets/icons/editar.svg',
                              onPressedIzquierdo: () =>
                                  mostrarOpcionesEditar(context),
                              textoDerecho: 'Cuenta',
                              iconoDerecho: 'assets/icons/cuenta.svg',
                              onPressedDerecho: () async {
                                print('[CuentaPage] Icono tocado');
                                final profileProvider =
                                    context.read<ProfileProvider>();

                                final response =
                                    await profileProvider.fetchUserProfile();
                                print(
                                    '[CuentaPage] Llamando a fetchUserProfile...');

                                if (response != null) {
                                  print(
                                      '[CuentaPage] Perfil cargado exitosamente. Navegando a CuentaPage.');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CuentaPage(),
                                    ),
                                  );
                                } else {
                                  print(
                                      '[CuentaPage] Error al cargar el perfil');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Error al cargar el perfil"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
