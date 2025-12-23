// lib/data/models/character_sheet.dart
import 'package:json_annotation/json_annotation.dart';

part 'character_sheet.g.dart';

/// Abstract base class for all character sheets
abstract class BaseCharacterSheet {
  String get id;
  String get systemName;
  String get characterName;
  Map<String, dynamic> get formData;
  DateTime get createdAt;
  DateTime get updatedAt;
}

@JsonSerializable()
class CharacterSheet implements BaseCharacterSheet {
  @override
  final String id;
  
  @override
  final String systemName;
  
  @override
  final String characterName;
  
  @override
  final Map<String, dynamic> formData;
  
  @override
  final DateTime createdAt;
  
  @override
  final DateTime updatedAt;

  CharacterSheet({
    required this.id,
    required this.systemName,
    required this.characterName,
    required this.formData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CharacterSheet.fromJson(Map<String, dynamic> json) => 
      _$CharacterSheetFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterSheetToJson(this);
}