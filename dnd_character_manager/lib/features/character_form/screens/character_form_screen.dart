// lib/features/character_form/screens/character_form_screen.dart
import 'package:flutter/material.dart';
import '../../../common/widgets/dynamic_form_widget.dart';
import '../../../core/utils/uuid_generator.dart';
import '../../../data/models/character_sheet.dart';
import '../../../data/repositories/character_repository_impl.dart';

class CharacterFormScreen extends StatefulWidget {
  final String systemName;
  final CharacterSheet? characterSheet;

  const CharacterFormScreen({
    Key? key,
    required this.systemName,
    this.characterSheet,
  }) : super(key: key);

  @override
  State<CharacterFormScreen> createState() => _CharacterFormScreenState();
}

class _CharacterFormScreenState extends State<CharacterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final CharacterRepositoryImpl _repository = CharacterRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.characterSheet != null 
            ? 'Edit Character' 
            : 'New Character (${widget.systemName})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Save character logic would go here
              if (_formKey.currentState?.validate() ?? false) {
                // Process form data and save
              }
            },
          ),
        ],
      ),
      body: DynamicFormWidget(
        systemName: widget.systemName,
        initialData: widget.characterSheet?.formData ?? {},
      ),
    );
  }
}