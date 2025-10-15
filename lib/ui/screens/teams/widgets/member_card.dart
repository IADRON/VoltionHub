import 'package:flutter/material.dart';
import '/data/models/employee.dart';

class MemberCard extends StatelessWidget {
  final Employee member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MemberCard({
    super.key,
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(member.name),
        subtitle: Text(member.role),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}