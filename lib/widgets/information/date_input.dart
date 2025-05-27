import 'package:flutter/material.dart';

class BirthdayField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final void Function(DateTime)? onDateChanged;

  const BirthdayField({
    super.key,
    required this.controller,
    this.label = "Fecha de nacimiento",
    this.validator,
    this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        label: Text(label, style: const TextStyle(color: Colors.black)),
        hintText: "Ej: 2002-04-25",
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
      validator: validator,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // Cierra teclado
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          locale: const Locale("es", "ES"),
        );
        if (picked != null) {
          controller.text = picked.toIso8601String().split('T')[0];
          if (onDateChanged != null) {
            onDateChanged!(picked);
          }
        }
      },
    );
  }
}
