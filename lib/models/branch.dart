// lib/models/branch.dart

import 'dart:convert';
import 'package:voltionhubapp/models/user.dart';

class Branch {
  final int id;
  final String name;
  final String address;
  final List<User> subAdmins;
  final int transformersNeedingMaintenance;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.subAdmins,
    required this.transformersNeedingMaintenance,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    List<dynamic> subAdminsDynamic = json['sub_admins'] is String
        ? jsonDecode(json['sub_admins'])
        : json['sub_admins'] ?? [];

    List<User> subAdminUsers = subAdminsDynamic.map((data) => User.fromJson(data)).toList();

    return Branch(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      subAdmins: subAdminUsers,
      transformersNeedingMaintenance: int.parse(json['transformers_needing_maintenance']?.toString() ?? '0'),
    );
  }
}