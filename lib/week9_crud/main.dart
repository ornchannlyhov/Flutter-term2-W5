import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/firebase_song_repository.dart';
import 'data/repositories/mock_song_repository.dart';
import 'data/repositories/song_repository.dart';
import 'providers/song_provider.dart';
import 'screens/song_list_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); 
  const bool useMockData = false; 
  final SongRepository songRepository =
      // ignore: dead_code
      useMockData ? MockSongRepository() : FirebaseSongRepository();

  runApp(MyApp(songRepository: songRepository));
}

class MyApp extends StatelessWidget {
  final SongRepository songRepository;

  const MyApp({super.key, required this.songRepository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SongProvider(songRepository),
      child: MaterialApp(
        title: 'Song Manager',
        debugShowCheckedModeBanner: false,
        theme: _buildAppTheme(),
        home: const SongListScreen(),
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, brightness: Brightness.light),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      listTileTheme:
          const ListTileThemeData(iconColor: Colors.deepPurpleAccent),
    );
  }
}
