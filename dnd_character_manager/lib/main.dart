import 'package:flutter/material.dart';
import 'package:dnd_character_manager/core/theme/app_theme.dart';
import 'package:dnd_character_manager/features/character_list/screens/character_list_screen.dart';

void main() {
  runApp(const DnDCharacterManagerApp());
}

class DnDCharacterManagerApp extends StatelessWidget {
  const DnDCharacterManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D Character Manager',
      theme: AppTheme.lightTheme,
      home: const CharacterListScreen(),
    );
  }
}