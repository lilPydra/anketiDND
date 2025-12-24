// lib/common/interfaces/character_repository.dart
import '../../data/models/character_sheet.dart';

abstract class CharacterRepository {
  Future<List<CharacterSheet>> getAllCharacters();
  Future<CharacterSheet> getCharacterById(String id);
  Future<void> saveCharacter(CharacterSheet character);
  Future<void> updateCharacter(CharacterSheet character);
  Future<void> deleteCharacter(String id);
  Future<List<CharacterSheet>> getCharactersBySystem(String systemName);
}