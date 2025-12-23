// lib/common/interfaces/form_provider.dart
import '../models/form_definition.dart';

abstract class FormProvider {
  Future<FormDefinition> getFormDefinition(String systemName);
  Future<List<FormDefinition>> getAllFormDefinitions();
  Future<void> saveFormDefinition(FormDefinition formDefinition);
  Future<void> updateFormDefinition(FormDefinition formDefinition);
  Future<void> deleteFormDefinition(String formId);
}

// lib/common/interfaces/character_repository.dart
import '../models/character_sheet.dart';

abstract class CharacterRepository {
  Future<List<CharacterSheet>> getAllCharacters();
  Future<CharacterSheet> getCharacterById(String id);
  Future<void> saveCharacter(CharacterSheet character);
  Future<void> updateCharacter(CharacterSheet character);
  Future<void> deleteCharacter(String id);
  Future<List<CharacterSheet>> getCharactersBySystem(String systemName);
}