import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: AppColors.azulVoltion,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              context,
              color: AppColors.vermelhoPerigo,
              count: 3,
              label: 'Ativos Offline',
            ),
            _buildSummaryItem(
              context,
              color: AppColors.amareloAlerta,
              count: 5,
              label: 'Alertas Ativos',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required Color color,
    required int count,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.branco,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}