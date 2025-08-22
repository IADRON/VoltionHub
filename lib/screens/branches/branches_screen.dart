// lib/screens/branches/branches_screen.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/branch.dart';
import 'package:voltionhubapp/screens/branches/branch_details_screen.dart';
import 'package:voltionhubapp/services/api_service.dart'; // Import ApiService
import 'widgets/branch_card.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Branch>> _branchesFuture;
  List<Branch> _allBranches = [];
  List<Branch> _filteredBranches = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBranches();
    _searchController.addListener(_filterBranches);
  }

  void _loadBranches() {
    _branchesFuture = _apiService.getBranches();
    _branchesFuture.then((branches) {
      setState(() {
        _allBranches = branches;
        _filteredBranches = branches;
      });
    });
  }

  void _filterBranches() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBranches = _allBranches.where((branch) {
        return branch.name.toLowerCase().contains(query) ||
               branch.address.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Branches',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Branch>>(
              future: _branchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No branches found.'));
                }

                return ListView.builder(
                  itemCount: _filteredBranches.length,
                  itemBuilder: (context, index) {
                    final branch = _filteredBranches[index];
                    return BranchCard(
                      branch: branch,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchDetailsScreen(branch: branch),
                          ),
                        );
                      },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}