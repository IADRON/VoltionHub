// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voltionhubapp/models/branch.dart';
import 'package:voltionhubapp/models/employee.dart';
import 'package:voltionhubapp/models/team.dart';
import 'package:voltionhubapp/models/user.dart';

class ApiService {
  final String _baseUrl = 'http://172.16.1.121:3000';

  // --- User Methods ---
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

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

  Future<Branch> addBranch(String name, String address, List<int> subAdminIds) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/branches'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'address': address, 'sub_admin_ids': subAdminIds}),
    );
    if (response.statusCode == 201) {
      return Branch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add branch');
    }
  }

  Future<Branch> updateBranch(int id, String name, String address, List<int> subAdminIds) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/branches/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'address': address, 'sub_admin_ids': subAdminIds}),
    );
    if (response.statusCode == 200) {
      return Branch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update branch');
    }
  }

  Future<void> deleteBranch(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/branches/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete branch');
    }
  }
  
  // ... outros métodos ...
  
  // --- Team Methods ---
  Future<Team> addTeam(String name, int branchId, int? responsibleId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/teams'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'branch_id': branchId, 'responsible_id': responsibleId}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add team');
    }
  }

  Future<Team> updateTeam(int teamId, String name, int? responsibleId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/teams/$teamId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'responsible_id': responsibleId}),
    );
    if (response.statusCode == 200) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update team');
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

  Future<Employee> updateEmployee(int id, String name, String role, int teamId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/employees/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'role': role, 'team_id': teamId}),
    );
    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(int employeeId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/employees/$employeeId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }

  // --- Transformers Methods ---

}