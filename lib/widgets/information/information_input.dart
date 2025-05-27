import 'package:flutter/material.dart';

class InformationInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String hintText;

  const InformationInput({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    required this.validator,
    this.obscureText = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          errorStyle: TextStyle(color: Colors.red),
        ),
        cursorColor: Colors.black,
        validator: validator,
      ),
    );
  }
}
