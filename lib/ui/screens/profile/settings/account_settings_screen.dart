import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações da Conta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Alterar Nome de Usuário'),
            subtitle: Text('fulano.silva'),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text('Alterar E-mail'),
            subtitle: Text('fulano.silva@email.com'),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text('Alterar Senha'),
            leading: Icon(Icons.lock),
          ),
        ],
      ),
    );
  }
}