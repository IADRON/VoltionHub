// lib/screens/teams/widgets/team_form_dialog.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/team.dart';
import 'package:voltionhubapp/models/user.dart';
import 'package:voltionhubapp/core/services/api/api_service.dart';

class TeamFormBottomSheet extends StatefulWidget {
  final Team? team;
  final int branchId;
  final ApiService apiService;
  final Function onSave;

  const TeamFormBottomSheet({
    super.key,
    this.team,
    required this.branchId,
    required this.apiService,
    required this.onSave,
  });

  @override
  State<TeamFormBottomSheet> createState() => _TeamFormBottomSheetState();
}

class _TeamFormBottomSheetState extends State<TeamFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  List<User> _allUsers = [];
  User? _selectedResponsible;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team?.name ?? '');
    _selectedResponsible = widget.team?.responsible;
    _loadUsers();
  }
  
  void _loadUsers() async {
    try {
      _allUsers = await widget.apiService.getUsers();
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _saveTeam() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (widget.team == null) {
          await widget.apiService.addTeam(_nameController.text, widget.branchId, _selectedResponsible?.id);
        } else {
          await widget.apiService.updateTeam(widget.team!.id, _nameController.text, _selectedResponsible?.id);
        }
        widget.onSave();
        Navigator.of(context).pop();
      } catch (e) {
        // Handle error
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.team == null ? 'New Team' : 'Edit Team', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
              validator: (value) => value!.isEmpty ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<User>(
              value: _selectedResponsible,
              decoration: const InputDecoration(labelText: 'Responsible'),
              items: _allUsers.map((User user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (User? newValue) {
                setState(() {
                  _selectedResponsible = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTeam,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}