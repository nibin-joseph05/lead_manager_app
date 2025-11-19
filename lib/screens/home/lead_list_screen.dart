import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lead.dart';
import '../../providers/lead_provider.dart';
import '../../widgets/lead_tile.dart';
import '../add/add_lead_screen.dart';
import '../details/lead_details_screen.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<LeadProvider>().loadLeads();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () =>
                context.read<LeadProvider>().exportToClipboard(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _push(const AddLeadScreen()),
        child: const Icon(Icons.add),
      ),
      body: Consumer<LeadProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final leads = provider.leads;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _SearchField(
                  controller: _searchController,
                  onChanged: provider.setSearch,
                  onClear: () {
                    _searchController.clear();
                    provider.setSearch('');
                  },
                ),
              ),
              _FilterBar(
                activeFilter: provider.filter,
                onSelected: provider.setFilter,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.loadLeads,
                  child: leads.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .4,
                            ),
                            _EmptyState(
                              onCreate: () => _push(const AddLeadScreen()),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemBuilder: (context, index) {
                            final lead = leads[index];
                            return LeadTile(
                              lead: lead,
                              onTap: () =>
                                  _push(LeadDetailsScreen(leadId: lead.id!)),
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemCount: leads.length,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _push(Widget page) {
    Navigator.of(context).push(_fadeRoute(page));
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search by name or contact',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(icon: const Icon(Icons.close), onPressed: onClear),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onSelected;

  const _FilterBar({required this.activeFilter, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final filters = ['all', ...LeadStatus.allStatuses];
    final labels = {
      'all': 'All',
      LeadStatus.newLead: 'New',
      LeadStatus.contacted: 'Contacted',
      LeadStatus.converted: 'Converted',
      LeadStatus.lost: 'Lost',
    };
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final value = filters[index];
          return FilterChip(
            selected: activeFilter == value,
            label: Text(labels[value]!),
            onSelected: (_) => onSelected(value),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_add_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No leads yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Tap below to add your first lead'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Add Lead'),
          ),
        ],
      ),
    );
  }
}

PageRouteBuilder _fadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
