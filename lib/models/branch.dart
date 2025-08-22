// lib/models/branch.dart

import 'dart:convert';

class Branch {
  final int id; // Changed to int
  final String name;
  final String address;
  final List<String> subAdmins;
  final int transformersNeedingMaintenance;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.subAdmins,
    required this.transformersNeedingMaintenance,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    // Handle JSONB from postgres which might be a string
    List<dynamic> subAdminsDynamic = json['sub_admins'] is String
        ? jsonDecode(json['sub_admins'])
        : json['sub_admins'];

    return Branch(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      subAdmins: List<String>.from(subAdminsDynamic),
      // The API calculates this value for us
      transformersNeedingMaintenance: int.parse(json['transformers_needing_maintenance'] ?? '0'),
    );
  }
}