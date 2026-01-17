import 'package:flutter/material.dart';
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