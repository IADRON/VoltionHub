// lib/screens/teams/widgets/team_form_dialog.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/team.dart';
import 'package:voltionhubapp/services/api_service.dart';

class TeamFormDialog extends StatefulWidget {
  final Team? team;
  final int branchId;
  final ApiService apiService;

  const TeamFormDialog({
    super.key,
    this.team,
    required this.branchId,
    required this.apiService,
  });

  @override
  State<TeamFormDialog> createState() => _TeamFormDialogState();
}

class _TeamFormDialogState extends State<TeamFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team?.name ?? '');
  }

  Future<void> _saveTeam() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (widget.team == null) {
          // Create new team
          await widget.apiService.addTeam(_nameController.text, widget.branchId);
        } else {
          // Update existing team
          await widget.apiService.updateTeam(widget.team!.id, _nameController.text);
        }
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save team: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.team == null ? 'New Team' : 'Edit Team'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Team Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a team name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveTeam,
          child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
        ),
      ],
    );
  }

    @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}