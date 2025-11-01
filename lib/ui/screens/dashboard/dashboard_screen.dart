import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/header.dart';
import 'widgets/map.dart';
import 'widgets/summary_card.dart';
import 'widgets/transformer_details_panel.dart';
import '/core/services/api/api_service.dart';
import '/data/models/transformer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transformer> transformers = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchTransformers();
  }

  Future<void> _fetchTransformers() async {
    final url = Uri.parse('${_apiService.baseUrl}/transformers');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          transformers = data.map((item) => Transformer(
                id: item['id'],
                status: item['status'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                capacity: item['capacity'],
                address: item['address'],
                lastMaintenance: item['last_maintenance'],
                )).toList();
        });
      }
    } catch (e) {
      print(e);
    }
  }

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
          MapWidget(
            transformers: transformers,
            onMarkerTapped: _onMarkerTapped,
          ),
          const SummaryCard(),
        ],
      ),
    );
  }
}