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
    Transformer(id: 'T001', status: 'online', latitude: -27.59537, longitude: -48.54804, details: 'Nº de série: 12345, Capacidade: 500kVA'),
    Transformer(id: 'T002', status: 'offline', latitude: -27.59690, longitude: -48.54910, details: 'Nº de série: 67890, Capacidade: 750kVA'),
    Transformer(id: 'T003', status: 'alerta', latitude: -27.59480, longitude: -48.54650, details: 'Nº de série: 13579, Superaquecimento detectado'),
  ];

  Transformer? selectedTransformer;

  void _onMarkerTapped(Transformer transformer) {
    setState(() {
      selectedTransformer = transformer;
    });
  }

  void _closePanel() {
    setState(() {
      selectedTransformer = null;
    });
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
          if (selectedTransformer != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TransformerDetailsPanel(
                transformer: selectedTransformer!,
                onClose: _closePanel,
              ),
            ),
          if (selectedTransformer == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SummaryCard(),
            ),
        ],
      ),
    );
  }
}