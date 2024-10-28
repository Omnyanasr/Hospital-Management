import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Icon icon;
  final Icon? suffixIcon; // Make suffixIcon nullable
  final TextEditingController mycontroller;
  final bool obscureText;
  final String? Function(String?)?
      validator; // New parameter to control text obscuring
  final TextStyle? hintStyle; // New parameter for hint text style

  const CustomTextForm({
    super.key,
    required this.hintText,
    required this.mycontroller,
    required this.labelText,
    required this.icon,
    this.suffixIcon, // Make suffixIcon optional
    this.obscureText = false,
    required this.validator, // Default is not obscure
    this.hintStyle, // Optional hintStyle
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      obscureText: obscureText, // Use the new parameter here
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: suffixIcon, // Optional suffixIcon
        labelText: labelText,
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(color: Colors.grey), // Default hint style
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
