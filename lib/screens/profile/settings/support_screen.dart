import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda e Suporte'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text('Perguntas Frequentes (FAQ)'),
            leading: Icon(Icons.quiz),
          ),
          ListTile(
            title: Text('Contatar Suporte Técnico'),
            leading: Icon(Icons.support_agent),
          ),
          ListTile(
            title: Text('Termos de Serviço'),
            leading: Icon(Icons.description),
          ),
          ListTile(
            title: Text('Política de Privacidade'),
            leading: Icon(Icons.privacy_tip),
          ),
        ],
      ),
    );
  }
}