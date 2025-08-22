// lib/screens/teams/teams_screen.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/team.dart';
import 'package:voltionhubapp/services/api_service.dart';
import 'widgets/team_card.dart';
import 'widgets/team_form_dialog.dart'; // We will create this next

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Team>> _teamsFuture;
   List<Team> _allTeams = [];
  List<Team> _filteredTeams = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeams();
    _searchController.addListener(_filterTeams);
  }

  void _loadTeams() {
    setState(() {
      _teamsFuture = _apiService.getTeams();
       _teamsFuture.then((teams) {
        setState(() {
          _allTeams = teams;
          _filteredTeams = teams;
        });
      });
    });
  }

  void _filterTeams() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeams = _allTeams.where((team) {
        return team.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showTeamForm({Team? team}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => TeamFormDialog(
        team: team,
        // For simplicity, I'm hardcoding branchId. In a real app,
        // you would pass the current sub-admin's branchId.
        branchId: 1,
        apiService: _apiService,
      ),
    );

    if (result == true) {
      _loadTeams(); // Reload the list if a team was added/edited
    }
  }

   void _deleteTeam(int teamId) async {
    try {
      await _apiService.deleteTeam(teamId);
      _loadTeams(); // Refresh list
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team deleted successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete team: $e'), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showTeamForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Teams',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Team>>(
              future: _teamsFuture,
              builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No teams found.'));
                }

                return ListView.builder(
                  itemCount: _filteredTeams.length,
                  itemBuilder: (context, index) {
                    final team = _filteredTeams[index];
                    return TeamCard(
                      team: team,
                      onEdit: () => _showTeamForm(team: team),
                      onDelete: () => _deleteTeam(team.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}