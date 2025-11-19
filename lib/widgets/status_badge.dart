import 'package:flutter/material.dart';

import '../models/lead.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        LeadStatus.label(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context) {
    switch (status) {
      case LeadStatus.contacted:
        return Colors.amber;
      case LeadStatus.converted:
        return Colors.green;
      case LeadStatus.lost:
        return Colors.redAccent;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
