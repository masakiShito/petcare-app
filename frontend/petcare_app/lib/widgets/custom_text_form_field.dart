import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
