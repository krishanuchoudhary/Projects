import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/fitness_log.dart';
import '../services/database_service.dart';
import '../widgets/progress_card.dart';
import '../widgets/stat_card.dart';
import 'history_screen.dart';
import 'log_activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;
  bool loading = true;
  DateTime selectedDay = DateTime.now();
  List<FitnessLog> todayLogs = [];
  List<FitnessLog> weekLogs = [];

  int get todaySteps => todayLogs.fold(0, (sum, item) => sum + item.steps);
  int get todayCalories => todayLogs.fold(0, (sum, item) => sum + item.calories);
  int get todayMinutes => todayLogs.fold(0, (sum, item) => sum + item.durationMinutes);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    final today = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final start = today.subtract(const Duration(days: 6));
    final results = await Future.wait([
      DatabaseService.instance.getLogsForDate(today),
      DatabaseService.instance.getLogsBetween(start, today),
    ]);
    if (!mounted) return;
    setState(() {
      todayLogs = results[0];
      weekLogs = results[1];
      loading = false;
    });
  }

  Future<void> _openLogger() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const LogActivityScreen()));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTrack', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: _refresh, tooltip: 'Refresh', icon: const Icon(Icons.refresh)),
        ],
      ),
      body: IndexedStack(index: tabIndex, children: [
        _dashboard(),
        const HistoryScreen(),
      ]),
      floatingActionButton: tabIndex == 0
          ? FloatingActionButton.extended(onPressed: _openLogger, icon: const Icon(Icons.add), label: const Text('Log activity'))
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (index) => setState(() => tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  Widget _dashboard() {
    if (loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          _greeting(),
          const SizedBox(height: 18),
          _dateStrip(),
          const SizedBox(height: 18),
          Row(children: [
            StatCard(label: 'Steps', value: '$todaySteps', unit: 'steps', icon: Icons.directions_walk_outlined),
            const SizedBox(width: 10),
            StatCard(label: 'Calories', value: '$todayCalories', unit: 'kcal', icon: Icons.local_fire_department_outlined),
            const SizedBox(width: 10),
            StatCard(label: 'Workout', value: '$todayMinutes', unit: 'minutes', icon: Icons.timer_outlined),
          ]),
          const SizedBox(height: 12),
          ProgressCard(title: 'Daily steps goal', value: todaySteps, goal: 10000, unit: 'steps', icon: Icons.directions_walk_outlined),
          ProgressCard(title: 'Daily calorie goal', value: todayCalories, goal: 500, unit: 'kcal', icon: Icons.local_fire_department_outlined),
          const SizedBox(height: 10),
          _sectionTitle('7-day progress'),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 18, 16),
              child: SizedBox(height: 230, child: _weeklyChart()),
            ),
          ),
          const SizedBox(height: 14),
          _sectionTitle('Today\'s activities'),
          const SizedBox(height: 10),
          if (todayLogs.isEmpty) _noActivities() else ...todayLogs.take(4).map(_todayActivity),
        ],
      ),
    );
  }

  Widget _greeting() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fitness dashboard', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(DateFormat('EEEE, d MMMM yyyy').format(selectedDay), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54)),
      ]);

  Widget _dateStrip() => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              IconButton(onPressed: () { setState(() => selectedDay = selectedDay.subtract(const Duration(days: 1))); _refresh(); }, icon: const Icon(Icons.chevron_left)),
              Expanded(child: Center(child: Text(_isToday(selectedDay) ? 'Today' : DateFormat('d MMM').format(selectedDay), style: const TextStyle(fontWeight: FontWeight.w800)))),
              IconButton(onPressed: _isToday(selectedDay) ? null : () { setState(() => selectedDay = selectedDay.add(const Duration(days: 1))); _refresh(); }, icon: const Icon(Icons.chevron_right)),
            ],
          ),
        ),
      );

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return now.year == day.year && now.month == day.month && now.day == day.day;
  }

  Widget _weeklyChart() {
    final now = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final values = List<double>.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return weekLogs.where((item) => item.date == _key(date)).fold<int>(0, (sum, item) => sum + item.steps).toDouble();
    });
    final maxValue = values.fold<double>(1000, (max, value) => value > max ? value : max);
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: maxValue * 1.25,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 42, getTitlesWidget: (value, meta) => Text(_compact(value), style: const TextStyle(fontSize: 10)))),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
            final i = value.toInt();
            if (i < 0 || i > 6) return const SizedBox.shrink();
            final d = now.subtract(Duration(days: 6 - i));
            return Padding(padding: const EdgeInsets.only(top: 8), child: Text(DateFormat('E').format(d).substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w700)));
          })),
        ),
        barGroups: values.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: e.value, width: 20, borderRadius: BorderRadius.circular(6))])).toList(),
      ),
    );
  }

  String _compact(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}k';
    return value.toInt().toString();
  }

  Widget _sectionTitle(String title) => Row(children: [Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const Spacer()]);

  Widget _todayActivity(FitnessLog log) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Icon(Icons.fitness_center, color: Theme.of(context).colorScheme.primary)),
          title: Text(log.type, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${log.durationMinutes} min  •  ${log.calories} kcal  •  ${log.steps} steps'),
        ),
      );

  Widget _noActivities() => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Icon(Icons.add_task, size: 44),
            const SizedBox(height: 8),
            const Text('Nothing logged yet', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            const Text('Use “Log activity” to add today\'s workout, steps or calories.', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: _openLogger, icon: const Icon(Icons.add), label: const Text('Add activity')),
          ]),
        ),
      );

  String _key(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
