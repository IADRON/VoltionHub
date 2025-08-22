// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voltionhubapp/models/branch.dart';
import 'package:voltionhubapp/models/team.dart';
import 'package:voltionhubapp/models/employee.dart';

class ApiService {
  // ATENÇÃO: Use o IP da sua máquina na rede, não localhost.
  final String _baseUrl = 'http://192.168.100.51:3000';

  // --- Branch Methods ---

  Future<List<Branch>> getBranches() async {
    final response = await http.get(Uri.parse('$_baseUrl/branches'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Branch.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }

  Future<List<Team>> getTeamsForBranch(int branchId) async {
    final response = await http.get(Uri.parse('$_baseUrl/branches/$branchId/teams'));
     if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Team.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load teams for branch');
    }
  }


  // --- Team Methods ---

  Future<List<Team>> getTeams() async {
    final response = await http.get(Uri.parse('$_baseUrl/teams'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Team.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load teams');
    }
  }

  Future<Team> addTeam(String name, int branchId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/teams'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'branch_id': branchId}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add team');
    }
  }

  Future<Team> updateTeam(int teamId, String name) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/teams/$teamId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    if (response.statusCode == 200) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update team');
    }
  }

  Future<void> deleteTeam(int teamId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/teams/$teamId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete team');
    }
  }

  // --- Employee Methods ---

  Future<Employee> addEmployee(String name, String role, int teamId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/employees'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'role': role, 'team_id': teamId}),
    );
     if (response.statusCode == 201) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add employee');
    }
  }

  Future<void> deleteEmployee(int employeeId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/employees/$employeeId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }
}