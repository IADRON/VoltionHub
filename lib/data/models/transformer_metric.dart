class TransformerMetric {
  final DateTime time;
  final String transformerId;
  final double? temperature;
  final double? voltage;
  final double? current;
  final double? harmonicDistortion;

  TransformerMetric({
    required this.time,
    required this.transformerId,
    this.temperature,
    this.voltage,
    this.current,
    this.harmonicDistortion,
  });

  // Construtor para criar uma instância a partir de um JSON
  factory TransformerMetric.fromJson(Map<String, dynamic> json) {
    return TransformerMetric(
      // Converte a string de data (formato ISO 8601) para um objeto DateTime
      time: DateTime.parse(json['time']),
      transformerId: json['transformer_id'],
      // Usa .toDouble() para garantir que os números sejam double, mesmo que venham como int
      temperature: json['temperature']?.toDouble(),
      voltage: json['voltage']?.toDouble(),
      current: json['current']?.toDouble(),
      harmonicDistortion: json['harmonic_distortion']?.toDouble(),
    );
  }

  // Método para converter a instância para um JSON (útil para enviar dados via POST)
  Map<String, dynamic> toJson() {
    return {
      // Converte o DateTime de volta para uma string no formato ISO 8601, que é o padrão
      'time': time.toIso8601String(),
      'transformer_id': transformerId,
      'temperature': temperature,
      'voltage': voltage,
      'current': current,
      'harmonic_distortion': harmonicDistortion,
    };
  }
}