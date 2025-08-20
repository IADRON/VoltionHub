import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segurança'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Autenticação Biométrica'),
            subtitle: const Text('Usar impressão digital para login'),
            value: false,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.fingerprint),
          ),
          const ListTile(
            title: Text('Autenticação de Dois Fatores (2FA)'),
            subtitle: Text('Desativado'),
            leading: Icon(Icons.phonelink_lock),
          ),
        ],
      ),
    );
  }
}