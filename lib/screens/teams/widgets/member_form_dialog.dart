// lib/screens/teams/widgets/member_form_dialog.dart

import 'package:flutter/material.dart';
import 'package:voltionhubapp/models/employee.dart';
import 'package:voltionhubapp/core/services/api/api_service.dart';

class MemberFormDialog extends StatefulWidget {
  final Employee? member;
  final int teamId;
  final ApiService apiService;

  const MemberFormDialog({
    super.key,
    this.member,
    required this.teamId,
    required this.apiService,
  });

  @override
  State<MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _roleController = TextEditingController(text: widget.member?.role ?? '');
  }

  Future<void> _saveMember() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (widget.member == null) {
          await widget.apiService.addEmployee(_nameController.text, _roleController.text, widget.teamId);
        } else {
          await widget.apiService.updateEmployee(widget.member!.id, _nameController.text, _roleController.text, widget.teamId);
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save member: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.member == null ? 'New Member' : 'Edit Member'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Member Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Role'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a role';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveMember,
          child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }
}