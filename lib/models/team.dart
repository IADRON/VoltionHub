// lib/models/team.dart

import 'employee.dart';

class Team {
  final int id; // Changed to int
  String name;
  final int branchId;
  List<Employee> members;

  Team({
    required this.id,
    required this.name,
    required this.branchId,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    var membersList = json['members'] as List;
    List<Employee> employeeMembers = membersList.map((i) => Employee.fromJson(i)).toList();

    return Team(
      id: json['id'],
      name: json['name'],
      branchId: json['branch_id'],
      members: employeeMembers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_id': branchId,
      'members': members.map((e) => e.toJson()).toList(),
    };
  }
}