import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/custom_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        CustomButton(
          text: 'Criar Ordem de Serviço',
          onPressed: () {
            // Lógica para criar OS
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                // Lógica para navegar
              },
              icon: Icon(Icons.navigation_outlined, color: Theme.of(context).colorScheme.primary),
              label: Text(
                'Navegar até o Local',
                style: GoogleFonts.inter(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Lógica para ver histórico
              },
              icon: Icon(Icons.history_outlined, color: Theme.of(context).colorScheme.primary),
              label: Text(
                'Ver Histórico',
                style: GoogleFonts.inter(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ],
    );
  }
}