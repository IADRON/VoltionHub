import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/map.dart';
import 'widgets/summary_card.dart';
import 'widgets/transformer_details_panel.dart';

class Transformer {
  final String id;
  final String status;
  final double latitude;
  final double longitude;
  final String details;

  Transformer({
    required this.id,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.details,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Transformer> transformers = [
    Transformer(id: 'TR-45881', status: 'alerta', latitude: -27.59537, longitude: -48.54804, details: 'Capacidade: 500kVA\nEndereço: Rua das Flores, 123\nÚltima Manutenção: 10/07/2025'),
    Transformer(id: 'TR-67890', status: 'offline', latitude: -27.59690, longitude: -48.54910, details: 'Capacidade: 750kVA\nEndereço: Av. Principal, 456\nÚltima Manutenção: 01/03/2025'),
    Transformer(id: 'TR-13579', status: 'online', latitude: -27.59480, longitude: -48.54650, details: 'Capacidade: 300kVA\nEndereço: Beco da Calesita, 789\nÚltima Manutenção: 15/08/2025'),
  ];

  void _onMarkerTapped(Transformer transformer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return TransformerDetailsPanel(
          transformer: transformer,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Stack(
        children: [
          Map(
            transformers: transformers,
            onMarkerTapped: _onMarkerTapped,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SummaryCard(),
          ),
        ],
      ),
    );
  }
}