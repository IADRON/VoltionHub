import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/history_event.dart';
import 'package:voltionhubapp/screens/dashboard/dashboard_screen.dart';

class TransformerHistoryScreen extends StatelessWidget {
  final Transformer transformer;

  const TransformerHistoryScreen({super.key, required this.transformer});

  // Dados mocados de histórico
  static final List<HistoryEvent> _historyEvents = [
    HistoryEvent(id: '1', date: DateTime(2025, 8, 1), description: 'Manutenção preventiva realizada, troca de óleo.', type: EventType.maintenance, author: 'Equipe A'),
    HistoryEvent(id: '2', date: DateTime(2025, 7, 22), description: 'Alerta de superaquecimento (95°C) registrado.', type: EventType.alert, author: 'Sistema'),
    HistoryEvent(id: '3', date: DateTime(2025, 3, 1), description: 'Instalação do Módulo de Monitoramento.', type: EventType.installation, author: 'Equipe C'),
    HistoryEvent(id: '4', date: DateTime(2024, 12, 5), description: 'Manutenção corretiva após falha na rede.', type: EventType.maintenance, author: 'Equipe B'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de ${transformer.id}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _historyEvents.length,
        itemBuilder: (context, index) {
          final event = _historyEvents[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: ListTile(
              leading: Icon(event.icon, color: Theme.of(context).colorScheme.primary),
              title: Text(event.description),
              subtitle: Text('${event.date.day}/${event.date.month}/${event.date.year} - por ${event.author}'),
            ),
          );
        },
      ),
    );
  }
}