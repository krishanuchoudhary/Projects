import 'package:flutter/material.dart';

import '../models/fitness_log.dart';
import '../services/database_service.dart';

class LogActivityScreen extends StatefulWidget {
  final FitnessLog? existing;
  const LogActivityScreen({super.key, this.existing});

  @override
  State<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends State<LogActivityScreen> {
  static const types = ['Walking', 'Running', 'Cycling', 'Gym', 'Yoga', 'Sports', 'Other'];
  late String selectedType;
  late DateTime selectedDate;
  late final TextEditingController durationController;
  late final TextEditingController caloriesController;
  late final TextEditingController stepsController;
  late final TextEditingController notesController;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    selectedType = item?.type ?? 'Walking';
    selectedDate = item == null ? DateTime.now() : DateTime.parse(item.date);
    durationController = TextEditingController(text: item == null ? '' : item.durationMinutes.toString());
    caloriesController = TextEditingController(text: item == null ? '' : item.calories.toString());
    stepsController = TextEditingController(text: item == null ? '' : item.steps.toString());
    notesController = TextEditingController(text: item?.notes ?? '');
  }

  @override
  void dispose() {
    durationController.dispose();
    caloriesController.dispose();
    stepsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  int _positiveInt(String value) => int.tryParse(value.trim()) ?? 0;

  Future<void> _save() async {
    if (saving) return;
    final duration = _positiveInt(durationController.text);
    final calories = _positiveInt(caloriesController.text);
    final steps = _positiveInt(stepsController.text);
    if (duration == 0 && calories == 0 && steps == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one fitness value.')));
      return;
    }

    setState(() => saving = true);
    final date = '${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final log = FitnessLog(
      id: widget.existing?.id,
      date: date,
      type: selectedType,
      durationMinutes: duration,
      calories: calories,
      steps: steps,
      notes: notesController.text.trim(),
      createdAt: widget.existing?.createdAt ?? DateTime.now().toIso8601String(),
    );

    if (widget.existing == null) {
      await DatabaseService.instance.insertLog(log);
    } else {
      await DatabaseService.instance.updateLog(log);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
    );
    if (result != null) setState(() => selectedDate = result);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit activity' : 'Log activity')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text('Record your workout or daily movement manually.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54)),
            const SizedBox(height: 22),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Activity type', prefixIcon: Icon(Icons.fitness_center)),
              items: types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => selectedType = value ?? selectedType),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Date', prefixIcon: Icon(Icons.calendar_today_outlined)),
                child: Text('${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'),
              ),
            ),
            const SizedBox(height: 14),
            _numberField(durationController, 'Workout time', 'minutes', Icons.timer_outlined),
            const SizedBox(height: 14),
            _numberField(caloriesController, 'Calories burned', 'kcal', Icons.local_fire_department_outlined),
            const SizedBox(height: 14),
            _numberField(stepsController, 'Steps', 'steps', Icons.directions_walk_outlined),
            const SizedBox(height: 14),
            TextField(controller: notesController, maxLines: 3, decoration: const InputDecoration(labelText: 'Notes (optional)', prefixIcon: Icon(Icons.notes_outlined))),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: saving ? null : _save,
              icon: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined),
              label: Text(saving ? 'Saving...' : editing ? 'Update activity' : 'Save activity'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label, String suffix, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, suffixText: suffix, prefixIcon: Icon(icon)),
    );
  }
}
