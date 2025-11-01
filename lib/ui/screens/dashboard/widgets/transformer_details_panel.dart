import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '/data/models/transformer.dart';
import '/core/common/constants/theme/app_colors.dart';
import '/data/models/transformer_metric.dart';
import '/core/services/api/api_service.dart';
import 'details_panel/action_buttons.dart';
import 'details_panel/metric_tile.dart';

class TransformerDetailsPanel extends StatefulWidget {
  final Transformer transformer;
  final VoidCallback onClose;

  const TransformerDetailsPanel({
    super.key,
    required this.transformer,
    required this.onClose,
  });

  @override
  State<TransformerDetailsPanel> createState() => _TransformerDetailsPanelState();
}

abstract class MetricState {}
class MetricLoading extends MetricState {}
class MetricError extends MetricState {
  final String message;
  MetricError(this.message);
}
class MetricSuccess extends MetricState {
  final TransformerMetric? latestMetric;
  MetricSuccess(this.latestMetric);
}

class _TransformerDetailsPanelState extends State<TransformerDetailsPanel> {
  final ApiService _apiService = ApiService();
  
  final ValueNotifier<MetricState> _metricState = ValueNotifier(MetricLoading());

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Busca os dados imediatamente quando o widget é criado
    _fetchLatestMetric();
    
    // NOVO: Inicia o Timer para atualizar os dados periodicamente
    _startFetchingPeriodically();
  }

  // NOVO: Método para iniciar o Timer
  void _startFetchingPeriodically() {
    _timer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
      // Chama a função de busca de dados sem exibir o loading novamente
      _fetchLatestMetric(showLoading: false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _metricState.dispose();
    super.dispose();
  }

  // Função para buscar a métrica mais recente
  // O parâmetro opcional 'showLoading' evita que o indicador de progresso apareça a cada atualização
  Future<void> _fetchLatestMetric({bool showLoading = true}) async {
    try {
      if (showLoading && mounted) {
          _metricState.value = MetricLoading();
      }

      final metrics = await _apiService.getTransformerMetrics(widget.transformer.id);
      
      if (mounted) {
        _metricState.value = MetricSuccess(metrics.isNotEmpty ? metrics.last : null);
      }
    } catch (e) {
      if (mounted) {
        _metricState.value = MetricError("Erro ao buscar dados.");
      }
    }
  }

  Color _getStatusColor(temperature) {
    if (temperature == 'N/A') {
      return Theme.of(context).colorScheme.onSurface;
    }

    final temp = double.tryParse(temperature.replaceAll('°C', ''));
    if (temp == null) {
      return Theme.of(context).colorScheme.onSurface;
    }

    if (temp > 105 && temp <= 115 || temp < 50) {
      return AppColors.alert;
    } else if (temp <= 105) {
        return AppColors.success;
    } else {
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.transformer.id,
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<MetricState>(
                      valueListenable: _metricState,
                      builder: (context, state, _) {
                        String temperatureValue = 'N/A';
                        if (state is MetricSuccess && state.latestMetric != null) {
                          final double? temp = state.latestMetric!.temperature;
                          temperatureValue = temp != null
                              ? '${temp.toStringAsFixed(1)}°C'
                              : 'N/A';
                        }
                        return Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(temperatureValue), // Passa a String
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            Divider(color: Theme.of(context).colorScheme.onSurface, height: 24),
            ValueListenableBuilder<MetricState>(
              valueListenable: _metricState,
              builder: (context, state, _) {
                if (state is MetricLoading) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                
                if (state is MetricError) {
                  return Center(child: Text(state.message));
                }
                
                if (state is MetricSuccess) {
                  return _buildMetrics(state.latestMetric);
                }
                
                // Estado inicial ou inesperado
                return Container(); 
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget separado para construir a lista de métricas e detalhes
  Widget _buildMetrics(TransformerMetric? metric) {
    final double? temp = metric?.temperature;
    final temperatureValue = temp != null
        ? '${temp.toStringAsFixed(1)}°C'
        : 'N/A';

    final double? harmonicDistortion = metric?.harmonicDistortion;
    final harmonicDistortionValue = harmonicDistortion != null
        ? '${harmonicDistortion.toStringAsFixed(1)}%'
        : 'N/A';

    final double? current = metric?.current;
    final currentValue = current != null
        ? '${current.toStringAsFixed(1)}A'
        : 'N/A';

    final double? voltage = metric?.voltage;
    final voltageValue = voltage != null
        ? '${voltage.toStringAsFixed(1)}V'
        : 'N/A';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricTile(
          icon: Icons.thermostat_outlined,
          label: 'Temperatura',
          value: temperatureValue,
          valueColor: _getStatusColor(temperatureValue),
        ),
        MetricTile(
          icon: Icons.flash_on_outlined,
          label: 'Tensão',
          value: voltageValue,
          valueColor: Theme.of(context).colorScheme.onSurface,
        ),
        MetricTile(
          icon: Icons.power_outlined,
          label: 'Corrente',
          value: currentValue,
          valueColor: Theme.of(context).colorScheme.onSurface,
        ),
        MetricTile(
          icon: Icons.waves,
          label: 'Distorção Harmônica',
          value: harmonicDistortionValue,
          valueColor: Theme.of(context).colorScheme.onSurface,
        ),
        const Gap(8),
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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Capacidade: ${widget.transformer.capacity}\nEndereço: ${widget.transformer.address}\nÚltima Manutenção: ${widget.transformer.lastMaintenance}",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        ActionButtons(transformer: widget.transformer),
      ],
    );
  }
}