import 'dart:convert';
import 'package:http/http.dart' as http;
import '/data/models/branch.dart';
import '/data/models/employee.dart';
import '/data/models/team.dart';
import '/data/models/transformer_metric.dart';
import '/data/models/user.dart';

class ApiService {
  // final String baseUrl = 'http://172.16.1.216:3000';
  final String baseUrl = 'http://192.168.100.51:3000';

  // --- User Methods ---
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // --- Branch Methods ---
  Future<List<Branch>> getBranches() async {
    final response = await http.get(Uri.parse('$baseUrl/branches'));
    if (response.statusCode == 200) {
      final decodedBody = json.decode(response.body);
      
      if (decodedBody is List) {
        return decodedBody.map((item) => Branch.fromJson(item)).toList();
      } 
      else if (decodedBody is Map<String, dynamic>) {
        if (decodedBody.containsKey('branches') && decodedBody['branches'] is List) {
          return (decodedBody['branches'] as List)
              .map((item) => Branch.fromJson(item))
              .toList();
        } else if (decodedBody.containsKey('data') && decodedBody['data'] is List) {
          return (decodedBody['data'] as List)
              .map((item) => Branch.fromJson(item))
              .toList();
        }
      }
      throw Exception('Failed to load branches: Unexpected JSON format');

    } else {
      throw Exception('Failed to load branches with status code: ${response.statusCode}');
    }
  }

  Future<Branch> addBranch(String name, String address, List<int> subAdminIds) async {
    final response = await http.post(
      Uri.parse('$baseUrl/branches'),
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
      Uri.parse('$baseUrl/branches/$id'),
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
    final response = await http.delete(Uri.parse('$baseUrl/branches/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete branch');
    }
  }
  
  // --- Team Methods ---
  Future<Team> addTeam(String name, int branchId, int? responsibleId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/teams'),
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
      Uri.parse('$baseUrl/teams/$teamId'),
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
    final response = await http.get(Uri.parse('$baseUrl/branches/$branchId/teams'));
      if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Team.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load teams for branch');
    }
  }

  Future<List<Team>> getTeams() async {
    final response = await http.get(Uri.parse('$baseUrl/teams'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Team.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load teams');
    }
  }

  Future<void> deleteTeam(int teamId) async {
    final response = await http.delete(Uri.parse('$baseUrl/teams/$teamId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete team');
    }
  }

  // --- Employee Methods ---
  Future<Employee> addEmployee(String name, String role, int teamId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employees'),
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
      Uri.parse('$baseUrl/employees/$id'),
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
    final response = await http.delete(Uri.parse('$baseUrl/employees/$employeeId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }

  // --- Transformers Methods ---

  // --- START: Transformer Metrics Methods ---

  Future<List<TransformerMetric>> getTransformerMetrics(
    String transformerId, {
    DateTime? start,
    DateTime? end,
  }) async {
    var uri = Uri.parse('$baseUrl/transformers/$transformerId/metrics');
    
    final Map<String, String> queryParameters = {};
    if (start != null) {
      queryParameters['start'] = start.toIso8601String();
    }
    if (end != null) {
      queryParameters['end'] = end.toIso8601String();
    }

    if (queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => TransformerMetric.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load metrics for transformer $transformerId');
    }
  }

  Future<TransformerMetric> addMetric(TransformerMetric metric) async {
    final response = await http.post(
      Uri.parse('$baseUrl/metrics'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(metric.toJson()),
    );
    
    if (response.statusCode == 201) {
      return TransformerMetric.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add metric');
    }
  }

  // --- END: Transformer Metrics Methods ---
}