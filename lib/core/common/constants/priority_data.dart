import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

class PriorityData {
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgente':
        return AppColors.danger;
      case 'média':
        return AppColors.orange;
      case 'baixa':
        return AppColors.alert;
      case 'em andamento':
        return AppColors.sucess;
      default:
        return AppColors.darkGrey;
    }
  }

  static IconData getPriorityIcon(String priority) {
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
}