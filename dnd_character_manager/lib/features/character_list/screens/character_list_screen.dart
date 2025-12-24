// lib/features/character_list/screens/character_list_screen.dart
import 'package:flutter/material.dart';
import '../../../common/services/character_service.dart';
import '../../../data/models/character_sheet.dart';
import '../../character_form/screens/character_form_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final CharacterService _characterService = CharacterService();
  List<CharacterSheet> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      final characters = await _characterService.getAllCharacters();
      setState(() {
        _characters = characters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading characters: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addCharacter() async {
    // For now, we'll navigate to a form selection screen
    // In a real app, you might want to select the game system first
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CharacterFormScreen(
          systemName: 'dnd_5e', // Default system for now
        ),
      ),
    );
    // Refresh the list after adding a character
    _loadCharacters();
  }

  Future<void> _editCharacter(CharacterSheet character) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterFormScreen(
          systemName: character.systemName,
          characterSheet: character,
        ),
      ),
    );
    // Refresh the list after editing
    _loadCharacters();
  }

  Future<void> _deleteCharacter(String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: const Text('Are you sure you want to delete this character?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _characterService.deleteCharacter(id);
        _loadCharacters(); // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Character deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting character: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCharacter,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCharacter,
        tooltip: 'Add Character',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _characters.isEmpty
              ? const Center(
                  child: Text(
                    'No characters yet.\nTap the + button to create one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadCharacters,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _characters.length,
                    itemBuilder: (context, index) {
                      final character = _characters[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: CircleAvatar(
                            child: Text(
                              character.characterName.isNotEmpty
                                  ? character.characterName.substring(0, 1).toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(
                            character.characterName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'System: ${character.systemName}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editCharacter(character);
                              } else if (value == 'delete') {
                                _deleteCharacter(character.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                          onTap: () => _editCharacter(character),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}