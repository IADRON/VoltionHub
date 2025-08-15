import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: isPassword 
          ? IconButton(
            icon: Icon(
              isPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Lógica para alternar a visibilidade da senha
            },
          ) : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: AppColors.textTheme.bodyLarge?.copyWith(color: AppColors.branco.withOpacity(0.7)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.branco),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.laranjaVoltion, width: 2),
        ),
      ),
    );
  }
}