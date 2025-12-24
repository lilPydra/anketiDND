// lib/common/interfaces/form_provider.dart
import '../../data/models/form_definition.dart';

abstract class FormProvider {
  Future<FormDefinition> getFormDefinition(String systemName);
  Future<List<FormDefinition>> getAllFormDefinitions();
  Future<void> saveFormDefinition(FormDefinition formDefinition);
  Future<void> updateFormDefinition(FormDefinition formDefinition);
  Future<void> deleteFormDefinition(String formId);
}