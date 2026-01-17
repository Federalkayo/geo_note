import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesRepository {
  static const String _key = 'geo_notes_list';

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Note.fromJson(e)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((note) => note.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.insert(0, note); // newest first
    await saveNotes(notes);
  }
}