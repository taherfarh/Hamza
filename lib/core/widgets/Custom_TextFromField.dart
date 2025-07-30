// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hamza/core/responsive/responsive_size.dart';

class CustomTextFromfield extends StatelessWidget {
  const CustomTextFromfield({
    super.key,
    required this.controlar,
    required this.validator,
    required this.label,
    required this.obscureText,
    required this.textInputType,
    required this.iconData,
    required this.function,
  });

  final TextEditingController controlar;
  final String validator;
  final String label;
  final bool obscureText;
  final TextInputType textInputType;
  final IconData iconData;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return validator;
            }
            return null;
          },
          controller: controlar,
          obscureText: obscureText,
          keyboardType: textInputType,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: ResponsiveSize(context: context, size: 18).size,
            ),
            suffixIcon: IconButton(
              onPressed: function,
              icon: Icon(iconData, color: Colors.grey.shade600),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            filled: true,
            fillColor: Colors.white,
            errorStyle: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
