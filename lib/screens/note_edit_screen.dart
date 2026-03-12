import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../viewmodels/note_view_model.dart';

class NoteEditScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const NoteEditScreen({super.key, required this.note, this.isNew = false});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _isPinned = widget.note.isPinned;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final vm = Provider.of<NoteViewModel>(context, listen: false);
    final now = DateTime.now().toUtc();
    final note = widget.note.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: now,
      isPinned: _isPinned,
    );
    // validation: title must not be empty
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El título no puede estar vacío')));
      return;
    }

    if (widget.isNew) {
      await vm.addNote(note);
    } else {
      await vm.updateNote(note);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'Crear nota' : 'Editar nota'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(hintText: 'Título', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(_isPinned ? Icons.star : Icons.star_border, color: _isPinned ? Colors.amber : theme.iconTheme.color),
                          onPressed: () => setState(() => _isPinned = !_isPinned),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: TextField(
                        controller: _contentController,
                        decoration: InputDecoration(hintText: 'Contenido', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: _save, child: const Text('Guardar')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
