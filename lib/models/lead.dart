class Lead {
  final int? id;
  final String name;
  final String contact;
  final String notes;
  final String status;

  const Lead({
    this.id,
    required this.name,
    required this.contact,
    this.notes = '',
    this.status = LeadStatus.newLead,
  });

  Lead copyWith({
    int? id,
    String? name,
    String? contact,
    String? notes,
    String? status,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }

  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'] as int?,
      name: map['name'] as String,
      contact: map['contact'] as String,
      notes: map['notes'] as String? ?? '',
      status: map['status'] as String? ?? LeadStatus.newLead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'notes': notes,
      'status': status,
    };
  }
}

class LeadStatus {
  static const newLead = 'new';
  static const contacted = 'contacted';
  static const converted = 'converted';
  static const lost = 'lost';

  static const allStatuses = [newLead, contacted, converted, lost];

  static String label(String status) {
    switch (status) {
      case contacted:
        return 'Contacted';
      case converted:
        return 'Converted';
      case lost:
        return 'Lost';
      default:
        return 'New';
    }
  }

  static String nextStatus(String current, {bool markLost = false}) {
    if (markLost) {
      return lost;
    }
    switch (current) {
      case newLead:
        return contacted;
      case contacted:
        return converted;
      default:
        return current;
    }
  }
}
