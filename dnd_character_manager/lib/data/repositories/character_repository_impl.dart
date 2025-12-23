// lib/data/repositories/character_repository_impl.dart
import '../models/character_sheet.dart';
import '../../common/interfaces/repository_interface.dart';
import '../../core/database/database_helper.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<CharacterSheet>> getAllCharacters() {
    return _databaseHelper.getAllCharacterSheets();
  }

  @override
  Future<CharacterSheet> getCharacterById(String id) async {
    // Implementation would retrieve specific character
    throw UnimplementedError();
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
  Future<List<CharacterSheet>> getCharactersBySystem(String systemName) {
    // Implementation would filter by system
    throw UnimplementedError();
  }
}