import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'settings/account_settings_screen.dart';
import 'settings/notifications_settings_screen.dart';
import 'settings/security_settings_screen.dart';
import 'settings/support_screen.dart';
import '/core/common/constants/theme/app_colors.dart';
import '/ui/screens/login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza que deseja sair?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sair'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil e Configurações'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          const Gap(20),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.orange,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const Gap(10),
          const Center(
            child: Text(
              'Nome do Usuário',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Text(
              'id_usuario@voltionhub.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const Gap(20),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações da Conta'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsSettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Segurança'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ajuda e Suporte'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text(
              'Sair',
              style: TextStyle(color: AppColors.danger),
            ),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }
}