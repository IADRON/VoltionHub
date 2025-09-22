// lib/screens/branches/widgets/branch_form_dialog.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/branch.dart';
import 'package:voltionhubapp/models/user.dart';
import 'package:voltionhubapp/core/services/api/api_service.dart';

class BranchFormDialog extends StatefulWidget {
  final Branch? branch;
  final ApiService apiService;
  final Function onSave;

  const BranchFormDialog({
    super.key,
    this.branch,
    required this.apiService,
    required this.onSave,
  });

  @override
  State<BranchFormDialog> createState() => _BranchFormDialogState();
}

class _BranchFormDialogState extends State<BranchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  List<User> _allUsers = [];
  List<User> _selectedAdmins = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.branch?.name ?? '');
    _addressController = TextEditingController(text: widget.branch?.address ?? '');
    _selectedAdmins = widget.branch?.subAdmins ?? [];
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

  Future<void> _saveBranch() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final adminIds = _selectedAdmins.map((user) => user.id).toList();
        if (widget.branch == null) {
          await widget.apiService.addBranch(_nameController.text, _addressController.text, adminIds);
        } else {
          await widget.apiService.updateBranch(widget.branch!.id, _nameController.text, _addressController.text, adminIds);
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
            Text(widget.branch == null ? 'New Branch' : 'Edit Branch', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Branch Name'),
              validator: (value) => value!.isEmpty ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) => value!.isEmpty ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<User>(
              decoration: const InputDecoration(labelText: 'Sub-Admins'),
              items: _allUsers.map((User user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (User? newValue) {
                if (newValue != null && !_selectedAdmins.any((admin) => admin.id == newValue.id)) {
                  setState(() {
                    _selectedAdmins.add(newValue);
                  });
                }
              },
            ),
            Wrap(
              children: _selectedAdmins.map((admin) => Chip(
                label: Text(admin.name),
                onDeleted: () {
                  setState(() {
                    _selectedAdmins.removeWhere((user) => user.id == admin.id);
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBranch,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}