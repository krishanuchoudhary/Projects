import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/fitness_log.dart';
import '../services/database_service.dart';
import 'log_activity_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<FitnessLog> logs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final items = await DatabaseService.instance.getRecentLogs(limit: 100);
    if (!mounted) return;
    setState(() {
      logs = items;
      loading = false;
    });
  }

  Future<void> _edit(FitnessLog log) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => LogActivityScreen(existing: log)));
    _load();
  }

  Future<void> _delete(FitnessLog log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete activity?'),
        content: const Text('This removes the record from your local fitness history.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true && log.id != null) {
      await DatabaseService.instance.deleteLog(log.id!);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity history')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? _empty()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: logs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _activityTile(logs[index]),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const LogActivityScreen()));
          _load();
        },
        icon: const Icon(Icons.add),
        label: const Text('Log'),
      ),
    );
  }

  Widget _activityTile(FitnessLog log) {
    final parsed = DateTime.parse(log.date);
    return Dismissible(
      key: ValueKey(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(18)),
        child: Icon(Icons.delete_outline, color: Colors.red.shade700),
      ),
      confirmDismiss: (_) async {
        await _delete(log);
        return false;
      },
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(14),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(_iconFor(log.type), color: Theme.of(context).colorScheme.primary),
          ),
          title: Text(log.type, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${DateFormat('EEE, d MMM').format(parsed)}  •  ${log.durationMinutes} min  •  ${log.calories} kcal  •  ${log.steps} steps'),
          trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(log)),
        ),
      ),
    );
  }

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.directions_run, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            const Text('No activities yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Log your first workout, steps, or calories to start building your history.', textAlign: TextAlign.center),
          ]),
        ),
      );

  IconData _iconFor(String type) {
    switch (type) {
      case 'Walking': return Icons.directions_walk_outlined;
      case 'Running': return Icons.directions_run_outlined;
      case 'Cycling': return Icons.directions_bike_outlined;
      case 'Gym': return Icons.fitness_center_outlined;
      case 'Yoga': return Icons.self_improvement_outlined;
      case 'Sports': return Icons.sports_soccer_outlined;
      default: return Icons.sports_outlined;
    }
  }
}
