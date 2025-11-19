import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/lead.dart';

class DbService {
  DbService._();

  static final DbService instance = DbService._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'leads.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE leads (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            contact TEXT NOT NULL,
            notes TEXT,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Lead>> getLeads() async {
    final db = await database;
    final maps = await db.query('leads', orderBy: 'id DESC');
    return maps.map(Lead.fromMap).toList();
  }

  Future<Lead> insertLead(Lead lead) async {
    final db = await database;
    final id = await db.insert('leads', lead.toMap());
    return lead.copyWith(id: id);
  }

  Future<void> updateLead(Lead lead) async {
    final db = await database;
    await db.update(
      'leads',
      lead.toMap(),
      where: 'id = ?',
      whereArgs: [lead.id],
    );
  }

  Future<void> deleteLead(int id) async {
    final db = await database;
    await db.delete('leads', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('leads');
  }
}
