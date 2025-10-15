// lib/models/employee.dart

class Employee {
  final int id; // Changed to int to match SERIAL
  final String name;
  final String role;
  final int teamId;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.teamId,
  });

  // Factory constructor to create an Employee from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      teamId: json['team_id'],
    );
  }

  // Method to convert an Employee to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'team_id': teamId,
    };
  }
}