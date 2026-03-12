import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/note_repository.dart';
import 'viewmodels/note_view_model.dart';
import 'screens/note_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure DB stream emits initial state
  await NoteRepository.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteViewModel(),
      child: MaterialApp(
        title: 'AppNotes',
        theme: ThemeData(useMaterial3: true),
        home: const NoteListScreen(),
      ),
    );
  }
}
