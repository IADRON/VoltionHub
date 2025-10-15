import 'package:flutter/material.dart';
import 'branch_details_screen.dart';
import 'widgets/branch_card.dart';
import 'widgets/branch_form_dialog.dart';
import '/core/services/api/api_service.dart';
import '/data/models/branch.dart';
import '/ui/widgets/textfield.dart';

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
    setState(() {
      _branchesFuture = _apiService.getBranches();
      _branchesFuture.then((branches) {
        setState(() {
          _allBranches = branches;
          _filteredBranches = branches;
        });
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

  void _showBranchForm({Branch? branch}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BranchFormDialog(
          branch: branch,
          apiService: _apiService,
          onSave: _loadBranches,
        ),
      ),
    );
  }

  void _deleteBranch(int id) async {
    try {
      await _apiService.deleteBranch(id);
      _loadBranches();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branch deleted successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete branch: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filiais'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showBranchForm(),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                controller: _searchController,
                  labelText: 'Procurar Filiais',
                  icon: Icons.search,
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
                        onEdit: () => _showBranchForm(branch: branch),
                        onDelete: () => _deleteBranch(branch.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}