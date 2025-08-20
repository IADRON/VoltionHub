import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({super.key});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  // -1 para a esquerda, 0 para o centro, 1 para a direita
  int _positionState = 0;

  Alignment get _alignment {
    switch (_positionState) {
      case -1:
        return Alignment.bottomLeft;
      case 1:
        return Alignment.bottomRight;
      default:
        return Alignment.bottomCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Align posiciona o card dentro do Stack na Dashboard
    return Align(
      alignment: _alignment,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Um limiar para evitar deslizes acidentais
          if (details.primaryDelta!.abs() > 2) {
            if (details.primaryDelta! > 0) { // Deslizando para a direita
              if (_positionState != 1) {
                setState(() => _positionState = 1);
              }
            } else { // Deslizando para a esquerda
              if (_positionState != -1) {
                setState(() => _positionState = -1);
              }
            }
          }
        },
        // AnimatedSwitcher troca entre o estado expandido e minimizado com uma animação
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _positionState == 0
              ? _buildExpandedView()
              : _buildMinimizedView(),
        ),
      ),
    );
  }

  // A visualização padrão, expandida e centralizada
  Widget _buildExpandedView() {
    return Card(
      key: const ValueKey('expanded'),
      margin: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSummaryItem(context, color: AppColors.vermelhoPerigo, count: 3, label: 'Offline'),
            _buildSummaryItem(context, color: AppColors.amareloAlerta, count: 5, label: 'Alertas'),
            _buildSummaryItem(context, color: AppColors.verdeSucesso, count: 1, label: 'Em Rota'),
          ],
        ),
      ),
    );
  }

  // A visualização minimizada que aparece nos cantos
  Widget _buildMinimizedView() {
    return Card(
      key: const ValueKey('minimized'),
      margin: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0), // Borda arredondada
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: () {
          setState(() {
            _positionState = 0; // Volta ao centro ao ser tocado
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Ocupa o mínimo de espaço
            children: [
              _buildMinimizedItem(AppColors.vermelhoPerigo, 3),
              const SizedBox(width: 10),
              _buildMinimizedItem(AppColors.amareloAlerta, 5),
              const SizedBox(width: 10),
              _buildMinimizedItem(AppColors.verdeSucesso, 1),
            ],
          ),
        ),
      ),
    );
  }

  // Item individual para a visualização minimizada (círculo colorido com número)
  Widget _buildMinimizedItem(Color color, int count) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Item para a visualização expandida
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}