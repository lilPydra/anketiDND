// lib/core/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/character_sheet.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'character_sheets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE character_sheets (
        id TEXT PRIMARY KEY,
        system_name TEXT,
        character_name TEXT,
        form_data TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }

  Future<int> insertCharacterSheet(CharacterSheet sheet) async {
    final db = await database;
    return await db.insert(
      'character_sheets',
      {
        'id': sheet.id,
        'system_name': sheet.systemName,
        'character_name': sheet.characterName,
        'form_data': sheet.formData.toString(), // In a real app, you'd serialize this properly
        'created_at': sheet.createdAt.toIso8601String(),
        'updated_at': sheet.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CharacterSheet>> getAllCharacterSheets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('character_sheets');

    return List.generate(maps.length, (i) {
      return CharacterSheet(
        id: maps[i]['id'],
        systemName: maps[i]['system_name'],
        characterName: maps[i]['character_name'],
        formData: _parseFormData(maps[i]['form_data']), // Parse the form data
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }

  // Helper to parse form data from string
  Map<String, dynamic> _parseFormData(String formDataString) {
    // In a real implementation, you'd properly deserialize this
    return {};
  }

  Future<int> updateCharacterSheet(CharacterSheet sheet) async {
    final db = await database;
    return await db.update(
      'character_sheets',
      {
        'system_name': sheet.systemName,
        'character_name': sheet.characterName,
        'form_data': sheet.formData.toString(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [sheet.id],
    );
  }

  Future<int> deleteCharacterSheet(String id) async {
    final db = await database;
    return await db.delete(
      'character_sheets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}