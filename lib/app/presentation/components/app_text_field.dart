import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final TextInputType? keyboardType;
  final bool readOnly;
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    required this.readOnly,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: readOnly ? const Color(0xFF7C7C7C) : const Color(0xFF393535),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF545454),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF7C7C7C),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF7C7C7C),
          ),
        ),
      ),
    );
  }
}
