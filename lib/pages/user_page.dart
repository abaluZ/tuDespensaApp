import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/icon_personalizado.dart';
import 'package:tudespensa/pages/account_page.dart';
import 'package:tudespensa/provider/profile_provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        title: Text('Perfil', style: TextStyle(fontSize: 26)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/images/logo.png', width: 40, height: 40),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Card(
                    color: Naranja,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      width: 400,
                      height: 161,
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 25,
                          bottom: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      Image.asset('assets/images/icon.png')
                                          .image,
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, child) {
                                    if (profileProvider.isLoading) {
                                      return const Text('Cargando...');
                                    } else {
                                      return Text(
                                        '${profileProvider.userModel?.username}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      );
                                    }
                                  },
                                ),
                                /* 
                                Text(
                                  'Antoni Juarez',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ), */
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgIcon(
                                              'assets/icons/calendario.svg',
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 4),
                                            Consumer<ProfileProvider>(
                                              builder: (context,
                                                  profileProvider, child) {
                                                if (profileProvider.isLoading) {
                                                  return const Text(
                                                      'Cargando...');
                                                } else {
                                                  return Text(
                                                    '${profileProvider.userModel?.edad}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            SvgIcon(
                                              'assets/icons/estadistica.svg',
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 4),
                                            Consumer<ProfileProvider>(
                                              builder: (context,
                                                  profileProvider, child) {
                                                if (profileProvider.isLoading) {
                                                  return const Text(
                                                      'Cargando...');
                                                } else {
                                                  return Text(
                                                    '${profileProvider.userModel?.peso}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      children: [
                                        SizedBox(width: 4),
                                        Text("Kcal a consumir",
                                            style: TextStyle(fontSize: 13)),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Text("1,588"),
                                            SizedBox(width: 4),
                                            SvgIcon(
                                              'assets/icons/cubiertos.svg',
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                            Text(
                              'Nombre',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Verde,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                                  if (profileProvider.isLoading) {
                                    return const Text('Cargando...');
                                  } else {
                                    return Text(
                                      '${profileProvider.userModel?.nombre}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Edad',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Verde,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                                  if (profileProvider.isLoading) {
                                    return const Text('Cargando...');
                                  } else {
                                    return Text(
                                      '${profileProvider.userModel?.edad}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Peso',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Verde,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                                  if (profileProvider.isLoading) {
                                    return const Text('Cargando...');
                                  } else {
                                    return Text(
                                      '${profileProvider.userModel?.peso}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Altura',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Verde,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                                  if (profileProvider.isLoading) {
                                    return const Text('Cargando...');
                                  } else {
                                    return Text(
                                      '${profileProvider.userModel?.estatura}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Genero',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Verde,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                                  if (profileProvider.isLoading) {
                                    return const Text('Cargando...');
                                  } else {
                                    return Text(
                                      '${profileProvider.userModel?.genero}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Fecha de nacimiento',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Verde,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Consumer<ProfileProvider>(
                                builder: (context, profileProvider, child) {
                                  if (profileProvider.isLoading) {
                                    return const Text('Cargando...');
                                  } else {
                                    return Text(
                                      '${profileProvider.userModel?.edad}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 13),
                            Row(
                              children: [
                                Text(
                                  'Editar',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/editar.svg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Spacer(flex: 2),
                                Text(
                                  'Cuenta',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CuentaPage(),
                                      ),
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/cuenta.svg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            )
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
