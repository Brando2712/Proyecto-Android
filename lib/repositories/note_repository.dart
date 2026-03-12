import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../data/note_db.dart';
import '../models/note.dart';

class NoteRepository {
  NoteRepository._private();
  static final NoteRepository instance = NoteRepository._private();

  final _controller = StreamController<List<Note>>.broadcast();

  Stream<List<Note>> get notesStream => _controller.stream;

  Future<Database> get _db async => (await NoteDatabase.instance.database);

  Future<List<Note>> getAll() async {
    final db = await _db;
    final maps = await db.query('notes', orderBy: 'isPinned DESC, updatedAt DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<void> insert(Note note) async {
    final db = await _db;
    await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await _emit();
  }

  Future<void> update(Note note) async {
    final db = await _db;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    await _emit();
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    await _emit();
  }

  Future<void> _emit() async {
    try {
      final list = await getAll();
      _controller.add(list);
    } catch (e) {
      _controller.addError(e);
    }
  }

  /// Public initializer to trigger an initial load / emit from outside the library.
  Future<void> init() async => await _emit();

  Future<void> dispose() async {
    await _controller.close();
    await NoteDatabase.instance.close();
  }
}
