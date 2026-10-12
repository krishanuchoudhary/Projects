class FitnessLog {
  final int? id;
  final String date;
  final String type;
  final int durationMinutes;
  final int calories;
  final int steps;
  final String notes;
  final String createdAt;

  const FitnessLog({
    this.id,
    required this.date,
    required this.type,
    required this.durationMinutes,
    required this.calories,
    required this.steps,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'duration_minutes': durationMinutes,
      'calories': calories,
      'steps': steps,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  factory FitnessLog.fromMap(Map<String, dynamic> map) {
    return FitnessLog(
      id: map['id'] as int?,
      date: map['date'] as String,
      type: map['type'] as String,
      durationMinutes: (map['duration_minutes'] as num).toInt(),
      calories: (map['calories'] as num).toInt(),
      steps: (map['steps'] as num).toInt(),
      notes: (map['notes'] ?? '') as String,
      createdAt: map['created_at'] as String,
    );
  }
}
