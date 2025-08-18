import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/service_order.dart';
import 'package:voltionhubapp/theme/app_colors.dart';

class ServiceOrderCard extends StatelessWidget {
  final ServiceOrder order;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ServiceOrderCard({
    super.key,
    required this.order,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: isSelected ? AppColors.laranjaVoltion.withOpacity(0.2) : null,
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (isSelectionMode)
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onTap(),
                ),
              if (isSelectionMode) const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text('${order.address}, ${order.neighborhood}'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            order.priority,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getPriorityColor(order.priority),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Text(
                          'Equipe: ${order.assignedTeam}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}