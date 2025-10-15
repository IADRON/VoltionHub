class ServiceOrder {
  final int id;
  final String transformer;
  final String address;
  final String neighborhood;
  final String priority;
  final String assignedTeam;
  final String problem;
  final DateTime timestamp;

  ServiceOrder({
    required this.id,
    required this.transformer,
    required this.address,
    required this.neighborhood,
    required this.priority,
    required this.assignedTeam,
    required this.problem,
    required this.timestamp,
  });
}