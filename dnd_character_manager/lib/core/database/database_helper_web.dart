// lib/core/database/database_helper_web.dart
// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;

import '../../common/interfaces/database_helper.dart';
import '../../data/models/character_sheet.dart';

DatabaseHelper getDatabaseHelper() => WebDatabaseHelper();

/// Web implementation backed by window.localStorage.
///
/// Data is stored under a single key [_storageKey] as a JSON-encoded
/// map of `{ id: rowMap }`.
class WebDatabaseHelper extends DatabaseHelper {
  static WebDatabaseHelper? _instance;
  factory WebDatabaseHelper() {
    _instance ??= WebDatabaseHelper._internal();
    return _instance!;
  }
  WebDatabaseHelper._internal();

  static const String _storageKey = 'character_sheets';

  // ---------- localStorage helpers ----------

  Map<String, dynamic> _readStorage() {
    final raw = html.window.localStorage[_storageKey];
    if (raw == null || raw.isEmpty) return {};
    return (jsonDecode(raw) as Map).cast<String, dynamic>();
  }

  void _writeStorage(Map<String, dynamic> data) {
    html.window.localStorage[_storageKey] = jsonEncode(data);
  }

  // ---------- interface ----------

  @override
  Future<List<CharacterSheet>> getAllCharacterSheets() async {
    final data = _readStorage();
    final sheets = data.values
        .map((v) => rowToSheet((v as Map).cast<String, dynamic>()))
        .toList();
    sheets.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sheets;
  }

  @override
  Future<CharacterSheet> getCharacterSheetById(String id) async {
    final data = _readStorage();
    if (!data.containsKey(id)) {
      throw StateError('Character sheet not found: $id');
    }
    return rowToSheet((data[id] as Map).cast<String, dynamic>());
  }

  @override
  Future<void> insertCharacterSheet(CharacterSheet sheet) async {
    final data = _readStorage();
    data[sheet.id] = sheetToRow(sheet);
    _writeStorage(data);
  }

  @override
  Future<void> updateCharacterSheet(CharacterSheet sheet) async {
    final data = _readStorage();
    final row = sheetToRow(sheet);
    row['updated_at'] = DateTime.now().toIso8601String();
    data[sheet.id] = row;
    _writeStorage(data);
  }

  @override
  Future<void> deleteCharacterSheet(String id) async {
    final data = _readStorage();
    data.remove(id);
    _writeStorage(data);
  }

  @override
  Future<List<CharacterSheet>> getCharacterSheetsBySystem(
      String systemName) async {
    final all = await getAllCharacterSheets();
    return all.where((s) => s.systemName == systemName).toList();
  }
}
