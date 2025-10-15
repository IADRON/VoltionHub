import 'dart:convert';
import '/data/models/user.dart';

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
    dynamic subAdminsRaw = json['sub_admins']; // Obtém o valor bruto

    List<dynamic> subAdminsList = [];

    if (subAdminsRaw is String) {
      try {
        // Tenta decodificar a string. Se for JSON válido, 'subAdminsRaw' vira Map ou List.
        subAdminsRaw = jsonDecode(subAdminsRaw);
      } catch (e) {
        // Se a decodificação falhar (FormatException), assume que é uma string simples (e-mail, etc.)
        // ou um formato inesperado, e mantém subAdminsList como vazia.
        print('Erro ao decodificar sub_admins como String: $e'); // Para depuração
      }
    }

    if (subAdminsRaw is List) {
      // Se for uma lista, usa diretamente
      subAdminsList = subAdminsRaw;
    } else if (subAdminsRaw is Map<String, dynamic> && subAdminsRaw.isNotEmpty) {
      // Se for um mapa não vazio, assume que é um único objeto User e o envolve em uma lista.
      subAdminsList = [subAdminsRaw];
    }
    // Se for um mapa vazio ou outro tipo inesperado, subAdminsList permanece vazia.


    List<User> subAdminUsers = subAdminsList.map((data) {
      if (data is Map<String, dynamic>) {
        return User.fromJson(data);
      }
      return null; // Ignora itens que não são mapas
    }).whereType<User>().toList(); // Filtra os nulos e cria a lista final de User

    return Branch(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      subAdmins: subAdminUsers,
      transformersNeedingMaintenance: int.parse(json['transformers_needing_maintenance']?.toString() ?? '0'),
    );
  }
}