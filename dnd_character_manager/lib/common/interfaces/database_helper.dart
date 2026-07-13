// lib/common/interfaces/database_helper.dart
import 'dart:convert';
import '../../data/models/character_sheet.dart';

/// Abstract database contract shared across all platforms.
///
/// Platform-specific implementations (SQLite for Android/iOS, localStorage
/// for the browser) live under `lib/core/database` and implement this class.
abstract class DatabaseHelper {
  Future<List<CharacterSheet>> getAllCharacterSheets();

  /// Returns the character with the given [id].
  /// Throws [StateError] if no such character exists.
  Future<CharacterSheet> getCharacterSheetById(String id);

  Future<void> insertCharacterSheet(CharacterSheet sheet);

  Future<void> updateCharacterSheet(CharacterSheet sheet);

  Future<void> deleteCharacterSheet(String id);

  Future<List<CharacterSheet>> getCharacterSheetsBySystem(String systemName);

  /// Serializes a [CharacterSheet] into a flat row (form_data as JSON string).
  Map<String, dynamic> sheetToRow(CharacterSheet sheet) => {
        'id': sheet.id,
        'system_name': sheet.systemName,
        'character_name': sheet.characterName,
        'form_data': jsonEncode(sheet.formData),
        'created_at': sheet.createdAt.toIso8601String(),
        'updated_at': sheet.updatedAt.toIso8601String(),
      };

  /// Reconstructs a [CharacterSheet] from a flat row.
  CharacterSheet rowToSheet(Map<String, dynamic> row) => CharacterSheet(
        id: row['id'] as String,
        systemName: row['system_name'] as String,
        characterName: row['character_name'] as String,
        formData:
            (jsonDecode(row['form_data'] as String) as Map).cast<String, dynamic>(),
        createdAt: DateTime.parse(row['created_at'] as String),
        updatedAt: DateTime.parse(row['updated_at'] as String),
      );
}
