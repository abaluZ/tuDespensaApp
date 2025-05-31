import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';
import 'package:tudespensa/pages/home_page.dart'; // Asegúrate de importar la página correcta

class UpdateGoalButton extends StatelessWidget {
  final dynamic goalProvider;
  final dynamic profileProvider;
  final Future<bool> Function(BuildContext context) onUpdate;

  const UpdateGoalButton({
    super.key,
    required this.goalProvider,
    required this.profileProvider,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Verde,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: goalProvider.isLoading
            ? null
            : () async {
                if (goalProvider.selectedGoal == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor selecciona su objetivo"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final success = await onUpdate(context);

                if (success) {
                  final profileSuccess =
                      await profileProvider.fetchUserProfile();

                  if (profileSuccess != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error al cargar el perfil"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fallo al actualizar el objetivo"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
        child: goalProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Actualizar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
