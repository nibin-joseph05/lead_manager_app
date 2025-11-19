import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lead.dart';
import '../../providers/lead_provider.dart';

class EditLeadScreen extends StatefulWidget {
  final Lead lead;

  const EditLeadScreen({super.key, required this.lead});

  @override
  State<EditLeadScreen> createState() => _EditLeadScreenState();
}

class _EditLeadScreenState extends State<EditLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _notesController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final lead = widget.lead;
    _nameController = TextEditingController(text: lead.name);
    _contactController = TextEditingController(text: lead.contact);
    _notesController = TextEditingController(text: lead.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Lead')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _Field(
              controller: _nameController,
              label: 'Name',
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _contactController,
              label: 'Contact',
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _Field(controller: _notesController, label: 'Notes', maxLines: 4),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _saving = true;
    });
    final updated = widget.lead.copyWith(
      name: _nameController.text.trim(),
      contact: _contactController.text.trim(),
      notes: _notesController.text.trim(),
    );
    await context.read<LeadProvider>().updateLead(updated);
    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
