import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'repositories/note_repository.dart';
import 'viewmodels/note_view_model.dart';
import 'screens/note_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Do not block app startup waiting for DB; initialization happens
  // asynchronously in the ViewModel so UI appears faster.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _spaceIndigo = Color(0xFF171738);
  static const Color _blueSlate = Color(0xFF61707D);
  static const Color _ashGrey = Color(0xFFBDBEA9);
  static const Color _darkKhaki = Color(0xFF393A10);
  static const Color _blackForest = Color(0xFF243010);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteViewModel(),
      child: MaterialApp(
        title: 'AppNotes',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: _spaceIndigo,
          scaffoldBackgroundColor: _ashGrey,
          appBarTheme: const AppBarTheme(
            backgroundColor: _spaceIndigo,
            foregroundColor: Colors.white,
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _blackForest),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _blackForest),
            bodyMedium: TextStyle(fontSize: 14, color: _blackForest),
            bodySmall: TextStyle(fontSize: 12, color: _blueSlate),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: _darkKhaki,
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: _spaceIndigo).copyWith(secondary: _blueSlate, background: _ashGrey),
        ),
        home: const NoteListScreen(),
      ),
    );
  }
}
