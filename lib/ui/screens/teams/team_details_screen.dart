import 'package:flutter/material.dart';
import 'widgets/member_card.dart';
import 'widgets/member_form_dialog.dart';
import '/core/services/api/api_service.dart';
import '/data/models/employee.dart';
import '/data/models/team.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Team team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  final ApiService _apiService = ApiService();
  late List<Employee> _members;

  @override
  void initState() {
    super.initState();
    _members = widget.team.members;
  }

  void _showMemberForm({Employee? member}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => MemberFormDialog(
        member: member,
        teamId: widget.team.id,
        apiService: _apiService,
      ),
    );

    if (result == true) {
      // Refresh the team details to get the updated member list
      // In a more complex app, you might just update the local list
      // For simplicity, we'll pop and let the previous screen refresh.
      Navigator.of(context).pop(true);
    }
  }

  void _deleteMember(int memberId) async {
    try {
      await _apiService.deleteEmployee(memberId);
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete member: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showMemberForm(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return MemberCard(
            member: member,
            onEdit: () => _showMemberForm(member: member),
            onDelete: () => _deleteMember(member.id),
          );
        },
      ),
    );
  }
}