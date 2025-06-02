import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/provider/calories_provider.dart';
import 'package:tudespensa/provider/photo_provider.dart';
import 'package:tudespensa/provider/profile_provider.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  void initState() {
    super.initState();
    // Cargar la foto del usuario al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final photoProvider = context.read<PhotoProvider>();
      final profileProvider = context.read<ProfileProvider>();
      if (profileProvider.userModel?.profilePhoto != null) {
        photoProvider.currentPhotoUrl = '${photoProvider.baseUrl}/${profileProvider.userModel!.profilePhoto}';
        print('[UserProfileCard] URL de la foto: ${photoProvider.currentPhotoUrl}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Naranja,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          width: 400,
          height: 161,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showPhotoOptions(context),
                child: Stack(
                  children: [
                    Consumer<PhotoProvider>(
                      builder: (context, photoProvider, child) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: photoProvider.currentPhotoUrl != null
                              ? NetworkImage(photoProvider.currentPhotoUrl!)
                              : const AssetImage('assets/images/icon.png') as ImageProvider,
                          child: photoProvider.isLoading
                              ? const CircularProgressIndicator()
                              : null,
                        );
                      },
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) {
                        if (profileProvider.isLoading) {
                          return const Text('Cargando...');
                        } else {
                          return Text(
                            '${profileProvider.userModel?.username ?? ""}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/calendario.svg',
                                  width: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Consumer<CaloriesProvider>(
                                  builder: (context, caloriesProvider, child) {
                                    if (caloriesProvider.isLoading) {
                                      return const Text('...');
                                    } else {
                                      final edad = caloriesProvider.caloriesModel?.data.informacionUsuario.edad ?? 0;
                                      return Text(
                                        '$edad años',
                                        style: const TextStyle(fontSize: 13),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/estadistica.svg',
                                  width: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, child) {
                                    if (profileProvider.isLoading) {
                                      return const Text('...');
                                    } else {
                                      return Text(
                                        '${profileProvider.userModel?.goal ?? ""}',
                                        style: const TextStyle(fontSize: 13),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            const Text(
                              "Kcal a consumir",
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Consumer<CaloriesProvider>(
                                  builder: (context, caloriesProvider, child) {
                                    if (caloriesProvider.isLoading) {
                                      return const Text('...');
                                    } else {
                                      final calorias = caloriesProvider.caloriesModel?.data.caloriasDiarias ?? 0;
                                      return Text(
                                        '$calorias',
                                        style: const TextStyle(fontSize: 13),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  'assets/icons/cubiertos.svg',
                                  width: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Cambiar foto'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<PhotoProvider>().pickAndUploadImage(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final photoProvider = context.read<PhotoProvider>();
                  final success = await photoProvider.deleteProfilePhoto();
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto eliminada exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(photoProvider.errorMessage ?? 'Error al eliminar la foto'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
