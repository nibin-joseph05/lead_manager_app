import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lead.dart';
import '../../providers/lead_provider.dart';
import '../../widgets/status_badge.dart';
import '../edit/edit_lead_screen.dart';

class LeadDetailsScreen extends StatelessWidget {
  final int leadId;

  const LeadDetailsScreen({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    final lead = context.select<LeadProvider, Lead?>((provider) {
      try {
        return provider.allLeads.firstWhere((item) => item.id == leadId);
      } catch (_) {
        return null;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          if (lead != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, lead),
            ),
        ],
      ),
      body: lead == null
          ? const Center(child: Text('Lead not found'))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lead.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StatusBadge(status: lead.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoTile(
                    icon: Icons.call_outlined,
                    label: 'Contact',
                    value: lead.contact,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: lead.notes.isEmpty ? 'No notes yet' : lead.notes,
                  ),
                  const Spacer(),
                  _Actions(lead: lead),
                ],
              ),
            ),
      floatingActionButton: lead == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _pushEdit(context, lead),
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
    );
  }

  void _pushEdit(BuildContext context, Lead lead) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => EditLeadScreen(lead: lead),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0, .1),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOut)),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Lead lead) async {
    final provider = context.read<LeadProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete lead'),
          content: Text('Delete ${lead.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await provider.deleteLead(lead.id!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final Lead lead;

  const _Actions({required this.lead});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LeadProvider>();
    final canAdvance =
        lead.status != LeadStatus.converted && lead.status != LeadStatus.lost;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: canAdvance
              ? () async {
                  final nextStatus = LeadStatus.nextStatus(lead.status);
                  await provider.advanceStatus(lead);
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Status updated to ${LeadStatus.label(nextStatus)}',
                      ),
                    ),
                  );
                }
              : null,
          child: Text(
            lead.status == LeadStatus.contacted
                ? 'Mark as Converted'
                : 'Progress Status',
          ),
        ),
        const SizedBox(height: 12),
        if (lead.status != LeadStatus.lost &&
            lead.status != LeadStatus.converted)
          OutlinedButton(
            onPressed: () async {
              await provider.advanceStatus(lead, markLost: true);
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Status updated to Lost')),
              );
            },
            child: const Text('Mark as Lost'),
          ),
      ],
    );
  }
}
