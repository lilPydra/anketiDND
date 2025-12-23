// lib/data/models/form_definition.dart
import 'package:json_annotation/json_annotation.dart';

part 'form_definition.g.dart';

enum FormFieldType {
  text,
  number,
  dropdown,
  checkbox,
  radio,
  textarea,
  section,
}

@JsonSerializable()
class FormField {
  final String id;
  final String label;
  final FormFieldType type;
  final String? placeholder;
  final List<String>? options; // For dropdown, radio
  final bool required;
  final dynamic defaultValue;
  final String? validationPattern;
  final String? validationMessage;

  FormField({
    required this.id,
    required this.label,
    required this.type,
    this.placeholder,
    this.options,
    this.required = false,
    this.defaultValue,
    this.validationPattern,
    this.validationMessage,
  });

  factory FormField.fromJson(Map<String, dynamic> json) => _$FormFieldFromJson(json);

  Map<String, dynamic> toJson() => _$FormFieldToJson(this);
}

@JsonSerializable()
class FormSection {
  final String id;
  final String title;
  final List<FormField> fields;

  FormSection({
    required this.id,
    required this.title,
    required this.fields,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) => _$FormSectionFromJson(json);

  Map<String, dynamic> toJson() => _$FormSectionToJson(this);
}

@JsonSerializable()
class FormDefinition {
  final String id;
  final String systemName;
  final String systemVersion;
  final String title;
  final List<FormSection> sections;

  FormDefinition({
    required this.id,
    required this.systemName,
    required this.systemVersion,
    required this.title,
    required this.sections,
  });

  factory FormDefinition.fromJson(Map<String, dynamic> json) => _$FormDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$FormDefinitionToJson(this);
}