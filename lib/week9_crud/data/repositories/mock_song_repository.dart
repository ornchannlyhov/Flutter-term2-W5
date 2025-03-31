import '../../models/song.dart';
import 'song_repository.dart';

class MockSongRepository implements SongRepository {
  // initial data
  static const List<Song> _songs = [
    Song(id: 'mock1', title: 'Stairway to Heaven', artist: 'Led Zeppelin'),
    Song(id: 'mock2', title: 'Bohemian Rhapsody', artist: 'Queen'),
    Song(id: 'mock3', title: 'Hotel California', artist: 'Eagles'),
  ];
  int _nextId = 4;

  Future<void> _simulateDelay([int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<Song> addSong({required String title, required String artist}) async {
    await _simulateDelay(300);
    // Simulate potential failure
    if (title.toLowerCase().contains('fail')) {
      throw Exception("Mock error: Failed to add song");
    }
    final newSong = Song(id: 'mock${_nextId++}', title: title, artist: artist);
    _songs.add(newSong);
    return newSong;
  }

  @override
  Future<List<Song>> getSongs() async {
    await _simulateDelay(800);
    return List.unmodifiable(_songs);
  }

  @override
  Future<void> removeSong(String songId) async {
    await _simulateDelay(200);
    // Simulate potential failure
    if (songId == 'mock2') {
      throw Exception("Mock error: Could not delete song");
    }
    _songs.removeWhere((song) => song.id == songId);
  }

  @override
  Future<void> updateSong(Song song) async {
    await _simulateDelay(400);
    // Simulate potential failure
    if (song.title.toLowerCase().contains('fail')) {
      throw Exception("Mock error: Failed to update song");
    }
    final index = _songs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _songs[index] = song;
    } else {
      // ignore: avoid_print
      print("Mock Warning: Song with id ${song.id} not found for update.");
    }
  }
}
