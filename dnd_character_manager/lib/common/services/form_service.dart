// lib/common/services/form_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../data/models/form_definition.dart';

class FormService {
  static const String _formsPath = 'assets/forms';

  Future<FormDefinition> getFormDefinition(String systemName) async {
    try {
      String path = '$_formsPath/$systemName/basic_form.json';
      String jsonString = await rootBundle.loadString(path);
      Map<String, dynamic> json = jsonDecode(jsonString);
      return FormDefinition.fromJson(json);
    } catch (e) {
      throw Exception('Failed to load form definition for system: $systemName');
    }
  }

  Future<List<FormDefinition>> getAllFormDefinitions() async {
    // This would scan all available forms
    // For now, returning empty list
    return [];
  }
}