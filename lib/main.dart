import 'package:flutter/material.dart';
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

