import 'package:flutter/material.dart';
import 'package:tudespensa/constants.dart';

class InformationButton extends StatelessWidget {
  final Future<bool> Function() onSave;
  final String buttonText;
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final Color backgroundColor;

  const InformationButton({
    super.key,
    required this.onSave,
    required this.buttonText,
    required this.isLoading,
    required this.formKey,
    this.backgroundColor = Naranja,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              if (formKey.currentState!.validate()) {
                await onSave(); // El onSave ya se encarga de todo
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
            ),
    );
  }
}
