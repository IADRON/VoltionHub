// lib/screens/teams/widgets/team_card.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/team.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TeamCard({
    super.key,
    required this.team,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // AQUI ESTÁ A CORREÇÃO:
                // Envolvemos o Text com Expanded para evitar o overflow.
                Expanded(
                  child: Text(
                    team.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis, // Evita quebra de linha se o nome for muito grande
                  ),
                ),
                Row(
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
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('${team.members.length} members'),
            const SizedBox(height: 12),
            ...team.members.map((member) => Text('- ${member.name} (${member.role})')),
          ],
        ),
      ),
    );
  }
}