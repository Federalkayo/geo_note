import 'package:flutter/material.dart';

import '../models/note.dart';
import '../repositories/notes_repository.dart';
import '../services/location_service.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository _repository = NotesRepository();
  final LocationService _locationService = LocationService();

  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await _repository.getNotes();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load notes";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addNote({
    required String title,
    required String content,
  }) async {
    if (title.trim().isEmpty || content.trim().isEmpty) {
      _errorMessage = "Title and content cannot be empty";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    // Changed from Position? to LocationData?
    final locationData = await _locationService.getCurrentPosition();

    if (locationData == null) {
      _errorMessage = "Couldn't get location. Note saved without location.";
      notifyListeners();
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      // location package returns nullable double
      latitude: locationData?.latitude ?? 0.0,
      longitude: locationData?.longitude ?? 0.0,
      createdAt: DateTime.now(),
    );

    await _repository.addNote(note);
    _notes.insert(0, note);

    _isLoading = false;
    _errorMessage = null;
    notifyListeners();

    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}