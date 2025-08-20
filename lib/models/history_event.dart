import 'package:flutter/material.dart';

enum EventType { maintenance, alert, installation, info }

class HistoryEvent {
  final String id;
  final DateTime date;
  final String description;
  final EventType type;
  final String author;

  HistoryEvent({
    required this.id,
    required this.date,
    required this.description,
    required this.type,
    required this.author,
  });

  IconData get icon {
    switch (type) {
      case EventType.maintenance:
        return Icons.build;
      case EventType.alert:
        return Icons.warning;
      case EventType.installation:
        return Icons.electrical_services;
      case EventType.info:
        return Icons.info;
    }
  }
}