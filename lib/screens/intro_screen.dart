import 'package:flutter/material.dart';
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