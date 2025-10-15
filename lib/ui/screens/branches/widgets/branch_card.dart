import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/core/common/constants/theme/app_colors.dart';
import '/data/models/branch.dart';

class BranchCard extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BranchCard({
    super.key,
    required this.branch,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      branch.name,
                      style: Theme.of(context).textTheme.titleLarge,
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
                  ),
                ],
              ),
              const Gap(8),
              Text(branch.address),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transformadores Precisando de Manutenção:'),
                  Text(
                    '${branch.transformersNeedingMaintenance}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}