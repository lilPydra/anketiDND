// lib/core/database/database_helper_mobile.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../common/interfaces/database_helper.dart';
import '../../data/models/character_sheet.dart';

DatabaseHelper getDatabaseHelper() => MobileDatabaseHelper();

/// Mobile / desktop implementation backed by SQLite via sqflite.
class MobileDatabaseHelper extends DatabaseHelper {
  static MobileDatabaseHelper? _instance;
  factory MobileDatabaseHelper() {
    _instance ??= MobileDatabaseHelper._internal();
    return _instance!;
  }
  MobileDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get _db async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'character_sheets.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE character_sheets (
          id           TEXT PRIMARY KEY,
          system_name  TEXT NOT NULL,
          character_name TEXT NOT NULL,
          form_data    TEXT NOT NULL,
          created_at   TEXT NOT NULL,
          updated_at   TEXT NOT NULL
        )
      '''),
    );
  }

  // ---------- interface ----------

  @override
  Future<List<CharacterSheet>> getAllCharacterSheets() async {
    final db = await _db;
    final rows = await db.query(
      'character_sheets',
      orderBy: 'updated_at DESC',
    );
    return rows.map(rowToSheet).toList();
  }

  @override
  Future<CharacterSheet> getCharacterSheetById(String id) async {
    final db = await _db;
    final rows = await db.query(
      'character_sheets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) throw StateError('Character sheet not found: $id');
    return rowToSheet(rows.first);
  }

  @override
  Future<void> insertCharacterSheet(CharacterSheet sheet) async {
    final db = await _db;
    await db.insert(
      'character_sheets',
      sheetToRow(sheet),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateCharacterSheet(CharacterSheet sheet) async {
    final db = await _db;
    final row = sheetToRow(sheet);
    row['updated_at'] = DateTime.now().toIso8601String();
    await db.update(
      'character_sheets',
      row,
      where: 'id = ?',
      whereArgs: [sheet.id],
    );
  }

  @override
  Future<void> deleteCharacterSheet(String id) async {
    final db = await _db;
    await db.delete(
      'character_sheets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<CharacterSheet>> getCharacterSheetsBySystem(
      String systemName) async {
    final db = await _db;
    final rows = await db.query(
      'character_sheets',
      where: 'system_name = ?',
      whereArgs: [systemName],
      orderBy: 'updated_at DESC',
    );
    return rows.map(rowToSheet).toList();
  }
}
