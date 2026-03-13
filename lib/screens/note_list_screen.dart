// ignore: unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../widgets/note_card.dart';
import '../viewmodels/note_view_model.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  String _query = '';
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NoteViewModel>(context);

    final notes = _query.isEmpty
        ? vm.notes
        : vm.notes.where((n) => n.title.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(hintText: 'Buscar por título', hintStyle: TextStyle(color: Colors.white70), border: InputBorder.none),
                onChanged: (v) => setState(() => _query = v),
              )
            : const Text('Notas'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              if (_searching) {
                _query = '';
              }
              _searching = !_searching;
            }),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // repository stream already updates; nothing to do
          return Future.value();
        },
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : notes.isEmpty
                ? const Center(child: Text('No hay notas'))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
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
                        child: NoteCard(
                          note: note,               
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)));
                          },
                          onLongPress: () async {
                            await showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(note.title.isEmpty ? '(Sin título)' : note.title),
                                content: SingleChildScrollView(
                                  child: Text(note.content.isEmpty ? '(Sin contenido)' : note.content),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cerrar')),
                                ],
                              ),
                            );
                          },
                          onFavorite: () async {
                            await vm.updateNote(note.copyWith(isPinned: !note.isPinned));
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
