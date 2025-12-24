// lib/features/character_form/screens/character_form_screen.dart
import 'package:flutter/material.dart';
import '../../../common/services/character_service.dart';
import '../../../common/widgets/dynamic_form_widget.dart';
import '../../../core/utils/uuid_generator.dart';
import '../../../data/models/character_sheet.dart';

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
  final CharacterService _characterService = CharacterService();
  late GlobalKey<DynamicFormWidgetState> _dynamicFormKey;

  @override
  void initState() {
    super.initState();
    _dynamicFormKey = GlobalKey<DynamicFormWidgetState>();
  }

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
            onPressed: _saveCharacter,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DynamicFormWidget(
              key: _dynamicFormKey,
              systemName: widget.systemName,
              initialData: widget.characterSheet?.formData ?? {},
              onFormChanged: (formData) {
                // Optional: Update UI based on form changes
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveCharacter,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                widget.characterSheet != null ? 'Update Character' : 'Save Character',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCharacter() async {
    final dynamicFormState = _dynamicFormKey.currentState;
    if (dynamicFormState != null) {
      if (dynamicFormState.validate()) {
        final formData = dynamicFormState.getFormData();
        
        // Get character name from form data (assuming there's a 'characterName' field)
        String characterName = formData['characterName']?.toString() ?? 'Unnamed Character';
        if (characterName.isEmpty) {
          characterName = 'Unnamed Character';
        }

        CharacterSheet character;
        if (widget.characterSheet != null) {
          // Update existing character
          character = CharacterSheet(
            id: widget.characterSheet!.id,
            systemName: widget.systemName,
            characterName: characterName,
            formData: formData,
            createdAt: widget.characterSheet!.createdAt,
            updatedAt: DateTime.now(),
          );
        } else {
          // Create new character
          character = CharacterSheet(
            id: UuidGenerator.generate(),
            systemName: widget.systemName,
            characterName: characterName,
            formData: formData,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        try {
          if (widget.characterSheet != null) {
            await _characterService.updateCharacter(character);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Character updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            await _characterService.saveCharacter(character);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Character updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
          Navigator.pop(context); // Go back to character list
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving character: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fix the errors in the form'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not access form data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}