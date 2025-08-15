import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/map.dart';
import 'widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Stack(
        children: [
          const Map(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SummaryCard(),
          ),
        ],
      ),
    );
  }
}