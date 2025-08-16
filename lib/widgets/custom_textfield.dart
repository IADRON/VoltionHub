import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon, 
        color: Theme.of(context).colorScheme.tertiary),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                color: Theme.of(context).colorScheme.tertiary,
                onPressed: onVisibilityToggle,
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: AppColors.textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onSurface),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.laranjaVoltion, width: 2),
        ),
      ),
    );
  }
}