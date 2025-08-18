import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voltionhubapp/screens/dashboard/widgets/details_panel/action_buttons.dart';
import 'package:voltionhubapp/screens/dashboard/widgets/details_panel/metric_tile.dart';
import '../../../screens/dashboard/dashboard_screen.dart'; 
import '../../../theme/app_colors.dart';

class TransformerDetailsPanel extends StatelessWidget {
  final Transformer transformer;
  final VoidCallback onClose;

  const TransformerDetailsPanel({
    super.key,
    required this.transformer,
    required this.onClose,
  });

  // Determina a cor do status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return AppColors.verdeSucesso;
      case 'offline':
        return AppColors.vermelhoPerigo;
      case 'alerta':
        return AppColors.amareloAlerta;
      default:
        return AppColors.branco;
    }
  }

  @override
  Widget build(BuildContext context) {
    // O widget principal agora é um Container para ser usado no BottomSheet
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      // Envolvemos o conteúdo com SingleChildScrollView para evitar overflow em telas menores
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Identificação Imediata
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      transformer.id,
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(transformer.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: onClose,
                ),
              ],
            ),
            Divider(color: Theme.of(context).colorScheme.onSurface, height: 24),

            // 2. Métricas Essenciais
            MetricTile(
              icon: Icons.thermostat_outlined,
              label: 'Temperatura',
              value: '85°C', // Valor de exemplo
              valueColor: _getStatusColor(transformer.status),
            ),
            MetricTile(
              icon: Icons.flash_on_outlined,
              label: 'Tensão',
              value: '218V', // Valor de exemplo
              valueColor: Theme.of(context).colorScheme.onSurface,
            ),
            MetricTile(
              icon: Icons.power_outlined,
              label: 'Corrente',
              value: '50A', // Valor de exemplo
              valueColor: Theme.of(context).colorScheme.onSurface,
            ),
            MetricTile(
              icon: Icons.vibration_outlined,
              label: 'Vibração',
              value: 'Normal', // Valor de exemplo
              valueColor: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 8),

            // 4. Informações de Cadastro (Expansível)
            ExpansionTile(
              title: Text(
                'Detalhes do Equipamento',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              iconColor: Theme.of(context).colorScheme.onSurface,
              collapsedIconColor: Theme.of(context).colorScheme.onSurface,
              children: [ // A lista de widgets filhos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      transformer.details,
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 3. Ações Contextuais
            const ActionButtons(),
          ],
        ),
      ),
    );
  }
}