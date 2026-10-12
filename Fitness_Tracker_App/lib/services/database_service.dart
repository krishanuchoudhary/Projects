import 'package:sqflite/sqflite.dart';

import '../models/fitness_log.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _dbName = 'codealpha_fitness_tracker.db';
  static const _dbVersion = 1;
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final path = '${await getDatabasesPath()}/$_dbName';
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE fitness_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            type TEXT NOT NULL,
            duration_minutes INTEGER NOT NULL DEFAULT 0,
            calories INTEGER NOT NULL DEFAULT 0,
            steps INTEGER NOT NULL DEFAULT 0,
            notes TEXT NOT NULL DEFAULT '',
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('CREATE INDEX idx_fitness_logs_date ON fitness_logs(date)');
      },
    );
  }

  Future<int> insertLog(FitnessLog log) async {
    final db = await database;
    final values = log.toMap()..remove('id');
    return db.insert('fitness_logs', values);
  }

  Future<int> updateLog(FitnessLog log) async {
    if (log.id == null) throw ArgumentError('A log id is required for update.');
    final db = await database;
    final values = log.toMap()..remove('id');
    return db.update('fitness_logs', values, where: 'id = ?', whereArgs: [log.id]);
  }

  Future<int> deleteLog(int id) async {
    final db = await database;
    return db.delete('fitness_logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FitnessLog>> getLogsForDate(DateTime date) async {
    final db = await database;
    final key = _dateKey(date);
    final rows = await db.query(
      'fitness_logs',
      where: 'date = ?',
      whereArgs: [key],
      orderBy: 'created_at DESC',
    );
    return rows.map(FitnessLog.fromMap).toList();
  }

  Future<List<FitnessLog>> getLogsBetween(DateTime start, DateTime end) async {
    final db = await database;
    final rows = await db.query(
      'fitness_logs',
      where: 'date >= ? AND date <= ?',
      whereArgs: [_dateKey(start), _dateKey(end)],
      orderBy: 'date DESC, created_at DESC',
    );
    return rows.map(FitnessLog.fromMap).toList();
  }

  Future<List<FitnessLog>> getRecentLogs({int limit = 10}) async {
    final db = await database;
    final rows = await db.query('fitness_logs', orderBy: 'date DESC, created_at DESC', limit: limit);
    return rows.map(FitnessLog.fromMap).toList();
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
