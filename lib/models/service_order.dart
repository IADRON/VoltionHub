class ServiceOrder {
  final String title;
  final String address;
  final String neighborhood;
  final String priority;
  final String assignedTeam;
  final String description;
  final DateTime timestamp; // Adicionado

  ServiceOrder({
    required this.title,
    required this.address,
    required this.neighborhood,
    required this.priority,
    required this.assignedTeam,
    required this.description,
    required this.timestamp, // Adicionado
  });
}