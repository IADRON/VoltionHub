class ServiceOrder {
  final int id; // <-- ADICIONADO
  final String title;
  final String address;
  final String neighborhood;
  final String priority;
  final String assignedTeam;
  final String description;
  final DateTime timestamp;

  ServiceOrder({
    required this.id, // <-- ADICIONADO
    required this.title,
    required this.address,
    required this.neighborhood,
    required this.priority,
    required this.assignedTeam,
    required this.description,
    required this.timestamp,
  });
}