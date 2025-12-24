// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_sheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterSheet _$CharacterSheetFromJson(Map<String, dynamic> json) =>
    CharacterSheet(
      id: json['id'] as String,
      systemName: json['systemName'] as String,
      characterName: json['characterName'] as String,
      formData: json['formData'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CharacterSheetToJson(CharacterSheet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'systemName': instance.systemName,
      'characterName': instance.characterName,
      'formData': instance.formData,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
