import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/provider/profile_provider.dart';

class ObjetivoUsuario extends StatelessWidget {
  final VoidCallback onEditar;

  const ObjetivoUsuario({
    Key? key,
    required this.onEditar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Text('Cargando...');
        }

        final objetivo = profileProvider.userModel?.goal ?? 'No definido';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Tu objetivo es',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  objetivo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEditar,
                  tooltip: 'Editar objetivo',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
