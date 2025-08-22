// lib/screens/branches/branch_details_screen.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/branch.dart';
import 'package:voltionhubapp/models/team.dart';
import 'package:voltionhubapp/services/api_service.dart'; // Import the ApiService

class BranchDetailsScreen extends StatefulWidget {
  final Branch branch;

  const BranchDetailsScreen({super.key, required this.branch});

  @override
  State<BranchDetailsScreen> createState() => _BranchDetailsScreenState();
}

class _BranchDetailsScreenState extends State<BranchDetailsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Team>> _teamsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch teams from the API when the screen loads
    _teamsFuture = _apiService.getTeamsForBranch(widget.branch.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.branch.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'Statistics'),
          _buildStatisticCard(
              'Transformers Needing Maintenance', '${widget.branch.transformersNeedingMaintenance}'),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Sub-Admins'),
          // This part remains the same, assuming subAdmins are loaded with the branch
          ...widget.branch.subAdmins.map((adminId) => ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(adminId), // In a real app, you might fetch user details here
              )),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Teams'),
          // Use a FutureBuilder to display teams from the API
          FutureBuilder<List<Team>>(
            future: _teamsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No teams found for this branch.'));
              }

              final teams = snapshot.data!;
              return Column(
                children: teams.map((team) => Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(team.name),
                    subtitle: Text('${team.members.length} members'),
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}