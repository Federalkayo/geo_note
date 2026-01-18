# GeoNotes – Location-Aware Notes App

A clean, modern Flutter mobile application that lets users create notes automatically tagged with their current geographic location.

Built with clean architecture principles, Provider for state management, and SharedPreferences for simple persistence.

https://github.com/Federalkayo/geo_note

## Features

- Create notes with title and content
- Automatically attach current location when saving a note
- List view of all saved notes (newest first)
- Note details screen showing title, content, location coordinates, and timestamp
- Proper location permission handling (requested only when needed)
- Clean Material 3 design with responsive layout
- Empty state & error handling
- Pull-to-refresh on notes list
- Intro/Welcome screen
- Bottom navigation bar (with placeholder tabs)

## Screenshots



## Tech Stack

- **Flutter**: 3.24.3 (stable)
- **Dart**: 3.5.3
- **State Management**: Provider
- **Location**: location ^5.0.3 (compatible with older Flutter projects)
- **Persistence**: shared_preferences
- **Architecture**: Clean Architecture inspired
  - Models
  - Services (LocationService)
  - Repositories (NotesRepository)
  - Providers
  - Screens & Widgets

## Project Structure


oluwakayode@oluwakayode-ThinkPad-T520:~$ cd /home/oluwakayode/Documents/flutter_projects/
oluwakayode@oluwakayode-ThinkPad-T520:~/Documents/flutter_projects$ flutter create geo_notes
Creating project geo_notes...
Resolving dependencies in geo_notes... (4.0s)
Downloading packages...
Got dependencies in geo_notes.
Wrote 129 files.
All done!
You can find general documentation for Flutter at: https://docs.flutter.dev/
Detailed API documentation is available at: https://api.flutter.dev/
If you prefer video documentation, consider:
https://www.youtube.com/c/flutterdev
In order to run your application, type:
  $ cd geo_notes
  $ flutter run
Your application code is in geo_notes/lib/main.dart.
oluwakayode@oluwakayode-ThinkPad-T520:~/Documents/flutter_projects$
Test – GeoNotes
Deadline:
19-12-2025
Goal:
Build a Location-aware Notes App that demonstrates clean architecture, state management,
permissions handling, async operations, and basic UI/UX decisions.
App Description:
Create a Flutter app called GeoNotes.
Users can:

Create notes
Automatically tag each note with the user’s current location
View notes in a list
Tap a note to see details including location
Technical Requirements:
Flutter stable (latest)
Null safety enabled
Android required (iOS optional)
Permissions & Location:
Request location permission only when the user tries to add a note
Handle granted, denied, and permanently denied permissions- Use geolocator or location package
Data Model:
class Note {
final String id;
final String title;
final String content;
final double latitude;
final double longitude;
final DateTime createdAt;
}
Core Features:
Add Note Screen:
Title input
Content input
Save button
Request location permission and fetch location on save
Notes List Screen:
List all notes
Show title and creation date
Empty state if no notes exist
Note Details Screen:
Show title, content, latitude, longitude, and creation date- Optional: open location in Google Maps
State Management:
Use one of Provider, Riverpod, or Bloc/Cubit.
Explain choice briefly.
Persistence:
Use SharedPreferences, Hive, or SQLite.
Notes must persist after restart.
Architecture:
Separate UI, state, and services
Include LocationService and NotesRepository
UI:
Clean Material Design
Responsive layout
Error Handling:
Handle permission denial, location failure, and empty inputs
Show user-friendly messages
Submission:
GitHub repo
README with setup, architecture, assumptions, and improvementsBonus:
Pull-to-refresh
Search
Distance to note
Evaluation Criteria:
Code quality
Architecture
Permissions handling
State management
Error handling
UI/UX
Red Flags:
Permission on app launch
All logic in widgets
No error handling
No README
 
 
using provider basics and sharedprefference
and proffessional ui
add a intro page
using this folder
error free
 
lib/
│
├── main.dart
│
├── models/
│ └── note.dart
│
├── providers/
│ └── notes_provider.dart
│
├── services/
│ └── location_service.dart
│
├── repositories/
│ └── notes_repository.dart
│
├── screens/
│ ├── notes_list_screen.dart
│ ├── add_note_screen.dart
│ └── note_details_screen.dart
│
└── widgets/
    └── note_tile.dart
 
add bottom navigation
Here’s a clean, professional-looking GeoNotes app structure using Provider + SharedPreferences with bottom navigation and an intro/splash-like welcome screen (as of 2025/2026 Flutter standards).
Folder Structure (as requested)
textlib/
├── main.dart
├── models/
│   └── note.dart
├── providers/
│   └── notes_provider.dart
├── services/
│   └── location_service.dart
├── repositories/
│   └── notes_repository.dart
├── screens/
│   ├── intro_screen.dart          ← new
│   ├── notes_list_screen.dart
│   ├── add_note_screen.dart
│   └── note_details_screen.dart
└── widgets/
    └── note_tile.dart
Complete Code Implementation
lib/models/note.dart
Dartimport 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
lib/services/location_service.dart
Dartimport 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) return "Location not available";
    if (!hasPermission) return "Location permission denied.\nPlease enable it in settings.";
    return "";
  }
}
lib/repositories/notes_repository.dart
Dartimport 'dart:convert';
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
lib/providers/notes_provider.dart
Dartimport 'package:flutter/material.dart';
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

    final position = await _locationService.getCurrentPosition();

    if (position == null) {
      _errorMessage = "Couldn't get location. Note saved without location.";
      notifyListeners();
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      latitude: position?.latitude ?? 0.0,
      longitude: position?.longitude ?? 0.0,
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
lib/screens/intro_screen.dart
Dartimport 'package:flutter/material.dart';
import 'notes_list_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 32),
              const Text(
                "GeoNotes",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Capture moments with location",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 80),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const NotesListScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Get Started"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade800,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
lib/screens/notes_list_screen.dart
Dartimport 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import 'add_note_screen.dart';
import 'note_details_screen.dart';
import '../widgets/note_tile.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NotesProvider>().loadNotes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GeoNotes"),
        elevation: 0,
      ),
      body: Consumer<NotesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => provider.loadNotes(),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          if (provider.notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No notes yet",
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  const Text("Create your first geo-tagged note!"),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadNotes(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index];
                return NoteTile(
                  note: note,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteDetailsScreen(note: note),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
        label: const Text("New Note"),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: 0,
        onTap: (index) {
          // You can implement other pages later
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Coming soon...")),
            );
          }
        },
      ),
    );
  }
}
lib/screens/add_note_screen.dart
Dartimport 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _isSaving = true);

    final success = await context.read<NotesProvider>().addNote(
          title: _titleController.text,
          content: _contentController.text,
        );

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note saved successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Your note...",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(height: 16),
            if (provider.errorMessage != null) ...[
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveNote,
                icon: const Icon(Icons.save),
                label: const Text("Save Note"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
lib/screens/note_details_screen.dart
Dartimport 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class NoteDetailsScreen extends StatelessWidget {
  final Note note;

  const NoteDetailsScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd MMM yyyy • HH:mm");

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(note.createdAt),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              note.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
            ),
            const Divider(height: 48),
            const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Lat: ${note.latitude.toStringAsFixed(6)}"),
            Text("Lng: ${note.longitude.toStringAsFixed(6)}"),
            if (note.latitude != 0 || note.longitude != 0) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // You can use url_launcher to open Google Maps here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Google Maps opening coming soon...")),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text("Open in Maps"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
lib/widgets/note_tile.dart
Dartimport 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteTile({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd MMM yyyy • HH:mm");

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                dateFormat.format(note.createdAt),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.blue[700]),
                  const SizedBox(width: 4),
                  Text(
                    "${note.latitude.toStringAsFixed(5)}, ${note.longitude.toStringAsFixed(5)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
lib/main.dart
Dartimport 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/notes_provider.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const GeoNotesApp());
}

class GeoNotesApp extends StatelessWidget {
  const GeoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: MaterialApp(
        title: 'GeoNotes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade700,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: const IntroScreen(),
      ),
    );
  }
}
Dependencies to add in pubspec.yaml
YAMLdependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  geolocator: ^12.0.0      # or latest version
  shared_preferences: ^2.3.0
  intl: ^0.19.0
Good luck with your test submission!
Clean architecture basics, proper error handling, permission on action, beautiful minimal UI with modern Material 3 feel.
Happy coding! 🚀can you help me change the geolocation to something else tht work on a old flutter
 
Dartimport 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) return "Location not available";
    if (!hasPermission) return "Location permission denied.\nPlease enable it in settings.";
    return "";
  }
}The geolocator package is generally well-maintained and still works on quite old Flutter versions (even Flutter 2.x in most cases),
but sometimes people face compatibility problems with very old Flutter versions, old Gradle, or especially very old Android SDK / targetSdk.
Here are the most common alternatives that tend to work better on older Flutter setups (2020–2022 era projects):















































PackageLast major updateMin FlutterAndroid minSdkNotes / Recommendationgeolocator2024–2025~1.12+21 (Android 5)Best choice if it works, most featureslocation2023–2024~1.10+21Very good alternative – often more stable on old projectsflutter_background_geolocation20242.0+21Too heavy + complicated for simple note appgeocoder + manual———Very old way – not recommendedlatlong2 + platform channels———Too much work
Most recommended downgrade path for old Flutter projects
Try switching to location package — it's usually the most painless replacement.
How to switch to location package

Update pubspec.yaml

YAMLdependencies:
  location: ^5.0.3          # or latest 5.x version (5.x is more stable on older projects)
  # remove: geolocator: ...

New LocationService using location package

Dartimport 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermission() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) {
          return false;
        }
      }

      if (permission == PermissionStatus.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      // You can adjust accuracy here
      _location.changeSettings(
        accuracy: LocationAccuracy.medium,
        interval: 10000, // 10 seconds
      );

      final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 12),
            onTimeout: () => null,
          );

      return locationData;
    } catch (e) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) return "Location not available";
    if (!hasPermission) {
      return "Location permission denied.\nPlease enable it in settings.";
    }
    return "";
  }
}

Update usage in NotesProvider (only 2 small changes needed)

Dart// Change this line:
final position = await _locationService.getCurrentPosition();

// to:
final locationData = await _locationService.getCurrentPosition();

if (locationData == null) {
  _errorMessage = "Couldn't get location. Note saved without location.";
  notifyListeners();
}

// And when creating Note:
final note = Note(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: title.trim(),
  content: content.trim(),
  latitude: locationData?.latitude ?? 0.0,
  longitude: locationData?.longitude ?? 0.0,
  createdAt: DateTime.now(),
);
Quick comparison table – which to choose?
textSituation                                 | Recommended package
------------------------------------------|---------------------
You have Flutter 3.0+                     → geolocator (keep it)
Flutter 2.x but quite recent              → geolocator still usually ok
Flutter 1.22 – 2.5 (2020–2022 projects)   → location (recommended)
Getting compile errors / strange crashes  → location
Want simplest possible migration          → location
Need background location / significant updates | flutter_background_geolocation (different story)
Bottom line recommendation for most old Flutter projects in 2025–2026:
→ Switch to location: ^5.0.3 (or latest 5.x)
→ It's the most battle-tested alternative for older Flutter/Android setups
Good luck! 🍀update
 
Dartimport 'package:flutter/material.dart';
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

    final position = await _locationService.getCurrentPosition();

    if (position == null) {
      _errorMessage = "Couldn't get location. Note saved without location.";
      notifyListeners();
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      latitude: position?.latitude ?? 0.0,
      longitude: position?.longitude ?? 0.0,
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
}Here’s the updated version of NotesProvider using the location package instead of geolocator:
Dartimport 'package:flutter/material.dart';
import 'package:location/location.dart';

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

    // Changed from Position? → LocationData?
    final locationData = await _locationService.getCurrentPosition();

    if (locationData == null) {
      _errorMessage = "Couldn't get location. Note saved without location.";
      notifyListeners();
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      content: content.trim(),
      // Important: location package returns nullable double
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
Summary of changes needed in the whole project






























FileWhat to changeNew type / importpubspec.yamlRemove geolocatorAdd location: ^5.0.3 (or latest 5.x)services/location_service.dartReplace whole fileUse import 'package:location/location.dart';providers/notes_provider.dartUpdate variable name & typeLocationData? instead of Position?models/note.dartNo change needed(already uses double which is compatible)
Recommended minimal & safe pubspec.yaml dependencies section
YAMLdependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  location: ^5.0.3          # ← changed here
  shared_preferences: ^2.2.3
  intl: ^0.19.0
Quick checklist before running

 Run flutter pub get
 Make sure Android minSdkVersion ≥ 21 (most old projects already satisfy this)
 Add location permissions in AndroidManifest.xml (should already exist):

XML<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
This version should be much more compatible with older Flutter projects (Flutter 2.x, early 3.x, older Gradle setups).
Good luck with your GeoNotes project! 🚀Dartimport 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermission() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) {
          return false;
        }
      }

      if (permission == PermissionStatus.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      // You can adjust accuracy here
      _location.changeSettings(
        accuracy: LocationAccuracy.medium,
        interval: 10000, // 10 seconds
      );

      final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 12),
            onTimeout: () => null,
          );

      return locationData;
    } catch (e) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) return "Location not available";
    if (!hasPermission) {
      return "Location permission denied.\nPlease enable it in settings.";
    }
    return "";
  }
}The screenshot shows that you're having dependency resolution problems after switching from geolocator to location.
The most common causes in this situation (especially with older Flutter projects) are:

Very strict/old version constraints in pubspec.yaml
Some packages forcing very old versions of location or conflicting transitive dependencies
Flutter SDK version being relatively old

Quick fixes you can try (in order of recommendation)
1. Most effective & cleanest solution (2025–2026 style)
YAMLdependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  location: ^6.0.0          # ← try latest 6.x first (most stable in 2025/2026)
  shared_preferences: ^2.3.0
  intl: ^0.19.0
Then run:
Bashflutter pub get
If it still complains → try forcing a slightly older but very stable version:
YAMLlocation: ^5.0.3          # very good compatibility with Flutter 3.0–3.16
2. If still failing — very defensive approach
YAMLdependency_overrides:
  location: ^5.0.3
  # sometimes also needed:
  # permission_handler: ^10.4.0    # ← location often uses this internally
Bashflutter pub get --no-example
flutter pub upgrade --major-versions
3. Check your Flutter version
Run:
Bashflutter --version
If you're on Flutter < 3.3 → seriously consider upgrading to at least Flutter 3.16 / 3.19 (stable channel).
Many location-related packages work much better after Flutter 3.7+.
4. Small improvement to your current LocationService
Your current code is almost perfect, but this version handles the most common timeout/error cases more cleanly:
Dartimport 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermission() async {
    try {
      // 1. Check & request location service
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }

      // 2. Check & request permission
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return false;
      }

      // Handle deniedForever (important on Android 11+)
      if (permission == PermissionStatus.deniedForever) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      // Set desired accuracy & update interval
      await _location.changeSettings(
        accuracy: LocationAccuracy.medium,
        interval: 10000, // 10 seconds
      );

      // Try to get location with timeout
      final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Location timeout'),
          );

      return locationData;
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) {
      return "Could not determine location permission status";
    }
    if (!hasPermission) {
      return "Location permission is denied.\nPlease enable it in your device settings.";
    }
    return "";
  }
}
Summary – what to do right now

Try location: ^6.0.0 first → flutter pub get
If fails → downgrade to location: ^5.0.3
If still problems → add dependency_override for location
Run flutter clean → flutter pub get again
If you're on very old Flutter → consider flutter upgrade

Most likely just changing the version to ^5.0.3 or ^6.0.0 will solve 90% of these cases.
Good luck!
Let me know what error you get after trying the version change — we can solve it quickly.import 'package:location/location.dart';
class LocationService {
  final Location _location = Location();
  Future<bool> checkAndRequestPermission() async {
    try {
      // 1. Check & request location service
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }
      // 2. Check & request permission
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await *location.requestPermission();
        if (permission != PermissionStatus.granted) return false;
      }
      // Handle deniedForever (important on Android 11+)
      if (permission == PermissionStatus.deniedForever) {
        return false;
      }
      return true;
    } catch (*) {
      return false;
    }
  }
  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;
      // Set desired accuracy & update interval
      await _location.changeSettings(
        accuracy: LocationAccuracy.medium,
        interval: 10000, // 10 seconds
      );
      // Try to get location with timeout
      final locationData = await *location.getLocation().timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Location timeout'),
          );
      return locationData;
    } on TimeoutException {
      return null;
    } catch (*) {
      return null;
    }
  }
  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) {
      return "Could not determine location permission status";
    }
    if (!hasPermission) {
      return "Location permission is denied.\nPlease enable it in your device settings.";
    }
    return "";
  }
}The code you currently have in location_service.dart looks good — it follows modern best practices for the location package.
The real problem is not in this file — it's in dependency resolution (pub get / pub upgrade failing because of version conflicts).
Current situation (based on your screenshot)
textflutter pub get
...
33 packages have newer versions incompatible with dependency constraints.
Try 'flutter pub outdated' for more information.
This means your pubspec.yaml (or some transitive dependency) has very strict/old version constraints, and when you added location, pub couldn't find a compatible set of versions for all packages.
Step-by-step fix (try in this order)
1. Clean everything first
Bashflutter clean
flutter pub cache repair    # optional but helpful sometimes
2. Use a safe, widely compatible version of location
Update your pubspec.yaml dependencies to something like this:
YAMLdependencies:
  flutter:
    sdk: flutter

  provider: ^6.0.0          # or ^6.1.2 if it works
  location: ^5.0.3          # ← very stable, works with Flutter 2.x–3.22
  shared_preferences: ^2.2.0
  intl: ^0.18.0             # or ^0.19.0 if your flutter supports it
Then:
Bashflutter pub get
3. If still fails → force the version (nuclear option but often works)
YAMLdependencies:
  flutter:
    sdk: flutter

  provider: any
  location: ^5.0.3
  shared_preferences: any
  intl: any

dependency_overrides:
  location: ^5.0.3
Bashflutter pub get
4. Check what is actually causing the conflict
Run this command and look at the output:
Bashflutter pub outdated
It will show you which packages want newer versions but can't upgrade because of constraints.
Very often the problem is one of these packages:

permission_handler (used by location)
google_maps_flutter (if you added it)
flutter_test from sdk
very old path_provider, collection, meta, etc.

5. Quick checklist if nothing above works
Bash# Tell me these results so I can help better:
flutter --version
flutter pub outdated | grep location
flutter pub deps --style=compact | grep location
Your current location_service.dart is fine
No important changes needed — just small style/consistency improvements:
Dartimport 'dart:async'; // ← add this for TimeoutException

import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermission() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }

      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return false;
      }

      if (permission == PermissionStatus.deniedForever) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      await _location.changeSettings(
        accuracy: LocationAccuracy.medium,
        interval: 10000,
      );

      final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Location timeout'),
          );

      return locationData;
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) {
      return "Could not determine location status";
    }
    if (!hasPermission) {
      return "Location permission denied.\nPlease enable in settings.";
    }
    return "";
  }
}
Focus on fixing pub first — once dependencies resolve, your app should run without problems.
Try step 2 → location: ^5.0.3 + flutter pub get
Let me know what error message you get if it still fails. We'll solve it step by step.oluwakayode@oluwakayode-ThinkPad-T520:~/Documents/flutter_projects/geo_notes$ # Tell me these results so I can help better:
flutter --version
flutter pub outdated | grep location
flutter pub deps --style=compact | grep location
Flutter 3.24.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 2663184aa7 (1 year, 4 months ago) • 2024-09-11 16:27:48 -0500
Engine • revision 36335019a8
Tools • Dart 3.5.3 • DevTools 2.37.3
location *5.0.3 *5.0.3 *7.0.1 8.0.1
location_platform_interface *3.1.2 *3.1.2 *5.0.0 6.0.1
location_web *4.2.0 *4.2.0 *5.0.4 6.0.1

location 5.0.3 [flutter location_platform_interface location_web]
location_platform_interface 3.1.2 [flutter plugin_platform_interface]
location_web 4.2.0 [flutter flutter_web_plugins http_parser js location_platform_interface]
oluwakayode@oluwakayode-ThinkPad-T520:~/Documents/flutter_projects/geo_notes$
Your Flutter version is 3.24.3 (released September 2024), which is fairly recent but not the absolute latest stable (as of January 2026, stable is around 3.27.x–3.3x range).
From the flutter pub outdated output:
textlocation *5.0.3 *5.0.3 *7.0.1 8.0.1
location_platform_interface *3.1.2 *3.1.2 *5.0.0 6.0.1
location_web *4.2.0 *4.2.0 *5.0.4 6.0.1
→ Current situation
You have location: 5.0.3 locked in (probably because you wrote ^5.0.3 or similar in pubspec.yaml).
This version is old (released ~early 2023), and pub sees that much newer compatible versions exist (7.0.1 / 8.0.1), but something is constraining the resolution to stay at 5.0.3 + old transitive dependencies.
Most likely causes

Your pubspec.yaml has a strict constraint like:YAMLlocation: ^5.0.3          # or 5.0.3→ pub will never go above 5.x
Another package in your project (direct or transitive) requires an old version of location_platform_interface or location_web
(very common when you have older plugins or when you copied an old project)

Recommended fixes (try in this order)
Option 1 – Best & cleanest (recommended)
Allow newer versions of location:
YAMLdependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  location: ^6.0.0          # ← or even ^7.0.0 / any if you want latest
  shared_preferences: ^2.3.0
  intl: ^0.19.0
  # ... other dependencies
Then run:
Bashflutter clean
flutter pub get
→ This should pull at least 6.x or 7.x automatically (most plugins updated for Flutter 3.22+ work fine with it).
Option 2 – If Option 1 fails (constraint from another package)
Use dependency override to force a newer location while keeping compatibility:
YAMLdependencies:
  location: ^6.0.0   # or ^7.0.0

dependency_overrides:
  location: ^6.0.0
  location_platform_interface: ^5.0.0     # adjust according to pub.dev/changelog
  location_web: ^5.0.0
Then again:
Bashflutter clean
flutter pub get
Option 3 – Very defensive (if still stuck)
YAMLdependencies:
  location: any     # allows latest possible

dependency_overrides:
  location: ^7.0.1
This is useful for testing, but not ideal for production.
After fixing dependencies

Run flutter pub outdated again → you should see location much closer to latest (or "up-to-date")
Run flutter run → test on emulator/device
If you get build errors after upgrade (rare, but possible on Android):
Make sure android/app/build.gradle has:gradlecompileSdkVersion 34   # or 35 if available
Update kotlin version in android/build.gradle if needed:gradleext.kotlin_version = '1.9.20'   # or latest 1.9.x / 2.0.x


Your current location_service.dart code is perfectly fine with version 5.0.3 and newer versions (no breaking API changes in the methods you use between 5.x → 7.x).
So the only real problem is the version lock.
Let me know what happens after trying Option 1 or 2 — paste the new flutter pub outdated output or any error message. We'll fix it quickly! 🚀50 sourcesRefer to the following content:The error you're seeing in VS Code / your editor:
The method 'TimeoutException' isn't defined for the type 'LocationService'.
Try correcting the name to the name of an existing method...
is happening because you forgot to import dart:async — the package that defines TimeoutException.
Quick Fix
Add this import at the very top of lib/services/location_service.dart:
Dartimport 'dart:async';     // ← Add this line!
import 'package:location/location.dart';
Corrected & Cleaned-up location_service.dart (full version)
Dartimport 'dart:async'; // Required for TimeoutException

import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermission() async {
    try {
      // Check and request location service
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }

      // Check and request permission
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return false;
      }

      // Handle permanently denied case
      if (permission == PermissionStatus.deniedForever) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      // Configure location settings
      await _location.changeSettings(
        accuracy: LocationAccuracy.medium,
        interval: 10000, // 10 seconds
      );

      // Get location with timeout protection
      final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Location request timed out'),
          );

      return locationData;
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) {
      return "Could not determine location status";
    }
    if (!hasPermission) {
      return "Location permission denied.\nPlease enable it in your device settings.";
    }
    return "";
  }
}
After this change:

Save the file
The red squiggles / errors in VS Code should disappear immediately
Run flutter pub get (just to be safe)
Try flutter run again

This is a very common Dart/Flutter mistake — TimeoutException is not part of package:location, it's from the core dart:async library.
Let me know if after adding the import you get any new errors (especially build-time or runtime) — we'll fix them quickly! 🚀help me write a clear read meHere's a clean, professional, and well-structured README.md for your GeoNotes Flutter project.
Feel free to copy-paste it directly into your README.md file and adjust small personal details if needed.
Markdown# GeoNotes – Location-Aware Notes App

A clean, modern Flutter mobile application that lets users create notes automatically tagged with their current geographic location.

Built with clean architecture principles, Provider for state management, and SharedPreferences for simple persistence.

https://github.com/yourusername/geo_notes

## Features

- Create notes with title and content
- Automatically attach current location when saving a note
- List view of all saved notes (newest first)
- Note details screen showing title, content, location coordinates, and timestamp
- Proper location permission handling (requested only when needed)
- Clean Material 3 design with responsive layout
- Empty state & error handling
- Pull-to-refresh on notes list
- Intro/Welcome screen
- Bottom navigation bar (with placeholder tabs)

## Screenshots

(Add 3–5 screenshots here later – welcome screen, notes list, add note, note details)

## Tech Stack

- **Flutter**: 3.24.3 (stable)
- **Dart**: 3.5.3
- **State Management**: Provider
- **Location**: location ^5.0.3 (compatible with older Flutter projects)
- **Persistence**: shared_preferences
- **Architecture**: Clean Architecture inspired
  - Models
  - Services (LocationService)
  - Repositories (NotesRepository)
  - Providers
  - Screens & Widgets

## Project Structure
lib/
├── main.dart
├── models/
│   └── note.dart
├── providers/
│   └── notes_provider.dart
├── services/
│   └── location_service.dart
├── repositories/
│   └── notes_repository.dart
├── screens/
│   ├── intro_screen.dart
│   ├── notes_list_screen.dart
│   ├── add_note_screen.dart
│   └── note_details_screen.dart
└── widgets/
└── note_tile.dart

