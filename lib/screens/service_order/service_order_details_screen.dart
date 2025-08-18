import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/widgets/custom_button.dart';
import 'package:voltionhubapp/theme/app_colors.dart';

class ServiceOrderDetailsScreen extends StatelessWidget {
  final ServiceOrder order;

  const ServiceOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Endereço:', '${order.address}, ${order.neighborhood}'),
            _buildDetailRow('Equipe Designada:', order.assignedTeam),
            _buildDetailRow('Prioridade:', order.priority,
                valueColor: _getPriorityColor(order.priority)),
            const Divider(height: 32),
            Text(
              'Descrição do Problema',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              order.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Histórico de atualizações e campo para notas/fotos
            // seriam adicionados aqui em uma implementação futura.
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: 'Iniciar Rota',
          onPressed: () {
            // Lógica para iniciar a roteirização
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

    Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgente':
        return AppColors.vermelhoPerigo;
      case 'alta':
        return AppColors.amareloAlerta;
      case 'média':
        return AppColors.azulVoltion;
      default:
        return AppColors.cinzaEscuro;
    }
  }
}