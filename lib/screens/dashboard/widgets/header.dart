import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Remove o back button que aparece por padrão
      automaticallyImplyLeading: false, 
      backgroundColor: Theme.of(context).colorScheme.background,
      
      // Use a propriedade 'title' para a logo
      title: Image.asset(
        'assets/images/VoltionHubTransparent&SombrasLogotipoHeader.png',
        height: 25,
      ),
      
      // Ações permanecem as mesmas
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.person, color: Theme.of(context).colorScheme.tertiary),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}