import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificação'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Notificações de Alertas Críticos'),
            value: true,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.warning),
          ),
          SwitchListTile(
            title: const Text('Notificações de Novas Ordens de Serviço'),
            value: true,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.assignment),
          ),
          SwitchListTile(
            title: const Text('Notificações de Manutenção Preventiva'),
            value: false,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.build),
          ),
        ],
      ),
    );
  }
}