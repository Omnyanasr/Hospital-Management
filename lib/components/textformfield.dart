import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Icon icon;
  final Icon? suffixIcon;
  final TextEditingController mycontroller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final int? maxLines;

  const CustomTextForm({
    super.key,
    required this.hintText,
    required this.mycontroller,
    required this.labelText,
    required this.icon,
    this.suffixIcon,
    this.obscureText = false,
    required this.validator,
    this.hintStyle,
    this.keyboardType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      keyboardType: keyboardType,
      maxLines:
          obscureText ? 1 : maxLines, // Ensure single line for obscure text
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
