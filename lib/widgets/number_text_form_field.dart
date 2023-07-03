import 'package:flutter/material.dart';

class NumberTextFormField extends StatelessWidget {
  const NumberTextFormField({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder()
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (double.tryParse(value ?? '') != null) return null;
        return "";
      },
    );
  }
}