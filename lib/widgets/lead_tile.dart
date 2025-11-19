import 'package:flutter/material.dart';

import '../models/lead.dart';
import 'status_badge.dart';

class LeadTile extends StatelessWidget {
  final Lead lead;
  final VoidCallback onTap;

  const LeadTile({super.key, required this.lead, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: .95, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: Alignment.centerLeft,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1,
            child: child,
          ),
        );
      },
      child: ListTile(
        onTap: onTap,
        title: Text(
          lead.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            lead.contact,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        trailing: StatusBadge(status: lead.status),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
