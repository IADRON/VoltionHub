import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.azulVoltion,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/voltion_logo.png',
          height: 20,
          width: 20,
        ),
      ),
      title: const Text(
        'VoltionHub',
        style: TextStyle(
          color: AppColors.branco,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.branco),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person, color: AppColors.branco),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}