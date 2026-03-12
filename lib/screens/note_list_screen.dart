import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../viewmodels/note_view_model.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NoteViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notas')),
      body: RefreshIndicator(
        onRefresh: () async {
          // repository stream already updates; force emit
          await vm.notes.isEmpty ? Future.value() : Future.value();
        },
        child: vm.notes.isEmpty
            ? const Center(child: Text('No hay notas'))
            : ListView.builder(
                itemCount: vm.notes.length,
                itemBuilder: (context, index) {
                  final note = vm.notes[index];
                  return Dismissible(
                    key: Key(note.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text('¿Eliminar esta nota?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await vm.deleteNote(note.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota eliminada')));
                        }
                        return true;
                      }
                      return false;
                    },
                    child: ListTile(
                      leading: note.isPinned ? const Icon(Icons.push_pin) : null,
                      title: Text(note.title.isEmpty ? '(Sin título)' : note.title),
                      subtitle: Text(note.updatedAt.toLocal().toString()),
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)));
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = Note.create(title: '', content: '');
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteEditScreen(note: newNote, isNew: true)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
