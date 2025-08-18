import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/theme/app_colors.dart';
import 'package:voltionhubapp/widgets/custom_button.dart';

class ServiceOrderDetailsScreen extends StatelessWidget {
  final ServiceOrder order;

  const ServiceOrderDetailsScreen({super.key, required this.order});

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgente':
        return AppColors.vermelhoPerigo;
      case 'média':
        return AppColors.laranjaVoltion;
      case 'baixa':
        return AppColors.amareloAlerta;
      case 'em andamento':
        return AppColors.verdeSucesso;
      default:
        return AppColors.cinzaEscuro;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgente':
        return Icons.warning;
      case 'média':
        return Icons.info;
      case 'baixa':
        return Icons.arrow_downward;
      case 'em andamento':
        return Icons.construction;
      default:
        return Icons.notifications;
    }
  }

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
            _buildDetailRow(
                'Data:',
                '${order.timestamp.day}/${order.timestamp.month}/${order.timestamp.year} às ${order.timestamp.hour}:${order.timestamp.minute.toString().padLeft(2, '0')}'),
            _buildDetailRow(
                'Endereço:', '${order.address}, ${order.neighborhood}'),
            _buildDetailRow('Equipe Designada:', order.assignedTeam),
            Row(
              children: [
                const Text(
                  'Prioridade:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: _getPriorityColor(order.priority),
                  child: Icon(
                    _getPriorityIcon(order.priority),
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  order.priority,
                  style: TextStyle(
                    color: _getPriorityColor(order.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
}