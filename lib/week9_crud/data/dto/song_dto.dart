import '../../models/song.dart';

class SongDto {
  // From Firebase JSON to Song Model
  static Song fromJson(String id, Map<String, dynamic> json) {
    return Song(
      id: id,
      title: json['title'] as String? ?? 'Unknown Title',
      artist: json['artist'] as String? ?? 'Unknown Artist',
    );
  }

  // From user input/Song Model to Firebase JSON (for POST/PATCH)
  static Map<String, dynamic> toJson(String title, String artist) {
    return {
      'title': title,
      'artist': artist,
    };
  }
}