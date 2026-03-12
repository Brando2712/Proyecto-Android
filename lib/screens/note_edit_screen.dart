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

    if (widget.isNew) {
      await vm.addNote(note);
    } else {
      await vm.updateNote(note);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'Crear nota' : 'Editar nota'),
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () => setState(() => _isPinned = !_isPinned),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Título'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: 'Contenido'),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
            ElevatedButton(onPressed: _save, child: const Text('Guardar'))
          ],
        ),
      ),
    );
  }
}
