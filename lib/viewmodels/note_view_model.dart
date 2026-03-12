import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../repositories/note_repository.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteRepository _repo = NoteRepository.instance;
  List<Note> _notes = [];
  StreamSubscription<List<Note>>? _sub;

  List<Note> get notes => _notes;

  NoteViewModel() {
    _sub = _repo.notesStream.listen((list) {
      _notes = list;
      notifyListeners();
    }, onError: (err) {
      // ignore errors for now
    });
  }

  Future<void> addNote(Note note) async {
    await _repo.insert(note);
  }

  Future<void> updateNote(Note note) async {
    await _repo.update(note.copyWith(updatedAt: DateTime.now().toUtc()));
  }

  Future<void> deleteNote(String id) async {
    await _repo.delete(id);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
