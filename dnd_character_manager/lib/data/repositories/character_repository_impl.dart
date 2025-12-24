// lib/data/repositories/character_repository_impl.dart
import '../models/character_sheet.dart';
import '../../common/interfaces/character_repository.dart';
import '../../core/database/database_helper.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<CharacterSheet>> getAllCharacters() {
    return _databaseHelper.getAllCharacterSheets();
  }

  @override
  Future<CharacterSheet> getCharacterById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'character_sheets',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return CharacterSheet(
        id: map['id'],
        systemName: map['system_name'],
        characterName: map['character_name'],
        formData: _parseFormData(map['form_data']),
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
    } else {
      throw Exception('Character with id $id not found');
    }
  }

  @override
  Future<void> saveCharacter(CharacterSheet character) {
    return _databaseHelper.insertCharacterSheet(character);
  }

  @override
  Future<void> updateCharacter(CharacterSheet character) {
    return _databaseHelper.updateCharacterSheet(character);
  }

  @override
  Future<void> deleteCharacter(String id) {
    return _databaseHelper.deleteCharacterSheet(id);
  }

  @override
  Future<List<CharacterSheet>> getCharactersBySystem(String systemName) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'character_sheets',
      where: 'system_name = ?',
      whereArgs: [systemName],
    );

    return List.generate(maps.length, (i) {
      return CharacterSheet(
        id: maps[i]['id'],
        systemName: maps[i]['system_name'],
        characterName: maps[i]['character_name'],
        formData: _parseFormData(maps[i]['form_data']),
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }

  // Helper to parse form data from string (same as in DatabaseHelper)
  Map<String, dynamic> _parseFormData(String formDataString) {
    // In a real implementation, you'd properly deserialize this
    return {};
  }
}