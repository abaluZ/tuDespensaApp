import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;

  const AuthInput({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    required this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
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
