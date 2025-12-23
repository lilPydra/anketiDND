// lib/features/character_list/screens/character_list_screen.dart
import 'package:flutter/material.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to form selection
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Character List will be displayed here'),
      ),
    );
  }
}