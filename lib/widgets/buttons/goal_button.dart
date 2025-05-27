import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';

class GoalButton extends StatelessWidget {
  final String text;
  final Widget nextPage;
  final dynamic goalProvider;
  final Future<bool> Function(BuildContext context) onSave;

  const GoalButton({
    super.key,
    required this.text,
    required this.nextPage,
    required this.goalProvider,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Verde, // puedes usar tu color 'Verde'
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
                    ),
                  );
                  return;
                }

                final success = await onSave(context);

                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => nextPage),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fallo al guardar el objetivo"),
                    ),
                  );
                }
              },
        child: goalProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
