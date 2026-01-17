import 'package:flutter/material.dart';
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
              decoration:  InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration:  InputDecoration(
                  labelText: "Your note...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
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