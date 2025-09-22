// lib/models/team.dart

import 'employee.dart';
import 'user.dart';

class Team {
  final int id;
  String name;
  final int branchId;
  final User? responsible; // Can be null
  List<Employee> members;

  Team({
    required this.id,
    required this.name,
    required this.branchId,
    this.responsible,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    var membersList = json['members'] as List;
    List<Employee> employeeMembers = membersList.map((i) => Employee.fromJson(i)).toList();

    return Team(
      id: json['id'],
      name: json['name'],
      branchId: json['branch_id'],
      responsible: json['responsible'] != null ? User.fromJson(json['responsible']) : null,
      members: employeeMembers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_id': branchId,
      'responsible_id': responsible?.id,
      'members': members.map((e) => e.toJson()).toList(),
    };
  }
}