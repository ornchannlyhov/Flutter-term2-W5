import '../../models/song.dart';

abstract class SongRepository {
  Future<List<Song>> getSongs();
  Future<Song> addSong({required String title, required String artist});
  Future<void> removeSong(String songId);
  Future<void> updateSong(Song song);
}
