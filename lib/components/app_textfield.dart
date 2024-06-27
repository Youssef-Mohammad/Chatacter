import 'package:flutter/material.dart';
import 'package:chatacter/styles/app_colors.dart';

class AppTextfield extends StatelessWidget {
  final String hint;
  const AppTextfield({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColors.fieldCursorColor,
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(color: AppColors.white),
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.transparent)),
        filled: true,
        fillColor: AppColors.fieldColor,
      ),
    );
  }
}
