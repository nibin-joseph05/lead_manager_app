import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/db_service.dart';
import '../models/lead.dart';

class LeadProvider extends ChangeNotifier {
  final DbService _db = DbService.instance;
  List<Lead> _leads = [];
  bool _isLoading = false;
  String _filter = 'all';
  String _search = '';

  List<Lead> get allLeads => _leads;
  List<Lead> get leads {
    final filtered = _filter == 'all'
        ? _leads
        : _leads.where((lead) => lead.status == _filter).toList();
    if (_search.isEmpty) {
      return filtered;
    }
    final query = _search.toLowerCase();
    return filtered
        .where(
          (lead) =>
              lead.name.toLowerCase().contains(query) ||
              lead.contact.toLowerCase().contains(query),
        )
        .toList();
  }

  bool get isLoading => _isLoading;
  String get filter => _filter;
  String get search => _search;

  Future<void> loadLeads() async {
    _isLoading = true;
    notifyListeners();
    _leads = await _db.getLeads();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLead(Lead lead) async {
    final created = await _db.insertLead(lead);
    _leads = [created, ..._leads];
    notifyListeners();
  }

  Future<void> updateLead(Lead lead) async {
    await _db.updateLead(lead);
    _leads = _leads.map((item) => item.id == lead.id ? lead : item).toList();
    notifyListeners();
  }

  Future<void> deleteLead(int id) async {
    await _db.deleteLead(id);
    _leads = _leads.where((lead) => lead.id != id).toList();
    notifyListeners();
  }

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  Future<void> advanceStatus(Lead lead, {bool markLost = false}) async {
    final next = LeadStatus.nextStatus(lead.status, markLost: markLost);
    if (next == lead.status) {
      return;
    }
    await updateLead(lead.copyWith(status: next));
  }

  Future<void> exportToClipboard(BuildContext context) async {
    final jsonString = jsonEncode(_leads.map((lead) => lead.toMap()).toList());
    await Clipboard.setData(ClipboardData(text: jsonString));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lead data copied to clipboard')),
      );
    }
  }
}
