import 'package:flutter/material.dart';
import 'package:voltionhubapp/screens/login/login_screen.dart';
import '../../../screens/dashboard/dashboard_screen.dart'; // Importa a classe Transformer
import '../../../theme/app_colors.dart';

class TransformerDetailsPanel extends StatelessWidget {
  final Transformer transformer;
  final VoidCallback onClose;

  const TransformerDetailsPanel({
    super.key,
    required this.transformer,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      color: AppColors.azulVoltion.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Título do painel[cite: 116].
                Text(
                  'Detalhes do Ativo: ${transformer.id}',
                  style: AppColors.textTheme.titleLarge?.copyWith(
                    color: AppColors.branco,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.branco),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Exibe o status com uma cor indicativa[cite: 109].
            Text(
              'Status: ${transformer.status.toUpperCase()}',
              style: AppColors.textTheme.bodyLarge?.copyWith(
                color: _getStatusColor(transformer.status),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Informações detalhadas do transformador[cite: 118].
            Text(
              transformer.details,
              style: AppColors.textTheme.bodyMedium?.copyWith(color: AppColors.branco.withOpacity(0.9)),
            ),
            const SizedBox(height: 20),
            // Botão de ação primário[cite: 58].
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.laranjaVoltion,
                foregroundColor: AppColors.branco,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                // Navegar para tela de ordem de serviço, por exemplo[cite: 124].
              },
              child: const Text('Criar Ordem de Serviço'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.greenAccent;
      case 'offline':
        return Colors.redAccent;
      case 'alerta':
        return Colors.yellowAccent;
      default:
        return AppColors.branco;
    }
  }
}