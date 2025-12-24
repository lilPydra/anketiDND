// lib/common/services/character_service.dart
import '../../data/models/character_sheet.dart';
import '../../data/repositories/character_repository_impl.dart';

class CharacterService {
  final CharacterRepositoryImpl _repository = CharacterRepositoryImpl();

  Future<List<CharacterSheet>> getAllCharacters() {
    return _repository.getAllCharacters();
  }

  Future<void> saveCharacter(CharacterSheet character) {
    return _repository.saveCharacter(character);
  }

  Future<void> updateCharacter(CharacterSheet character) {
    return _repository.updateCharacter(character);
  }

  Future<void> deleteCharacter(String id) {
    return _repository.deleteCharacter(id);
  }

  Future<CharacterSheet> getCharacterById(String id) {
    return _repository.getCharacterById(id);
  }

  Future<List<CharacterSheet>> getCharactersBySystem(String systemName) {
    return _repository.getCharactersBySystem(systemName);
  }
}