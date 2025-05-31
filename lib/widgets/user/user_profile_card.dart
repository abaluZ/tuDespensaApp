import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/provider/profile_provider.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

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
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/icon.png'),
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
                                Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, child) {
                                    if (profileProvider.isLoading) {
                                      return const Text('...');
                                    } else {
                                      return Text(
                                        '${profileProvider.userModel?.edad ?? ""}',
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
                                const Text("1,588"),
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
}
