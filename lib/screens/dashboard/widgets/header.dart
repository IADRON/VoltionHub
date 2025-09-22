import 'package:flutter/material.dart';
import 'package:voltionhubapp/core/common/constants/app_assets.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, 
      backgroundColor: Theme.of(context).colorScheme.background,
      
      title: Image.asset(
        AppAssets.head,
        height: 25,
      ),
      
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}