import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/song.dart';
import '../dto/song_dto.dart';
import 'song_repository.dart';

class FirebaseSongRepository implements SongRepository {
  static const String _baseUrl =
      'https://fb-testing-db-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String _songsCollection = "songs";
  static const String _allSongsUrl = '$_baseUrl/$_songsCollection.json';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json'
  };

  FirebaseSongRepository();

  String _songUrl(String songId) => '$_baseUrl/$_songsCollection/$songId.json';

  @override
  Future<Song> addSong({required String title, required String artist}) async {
    final uri = Uri.parse(_allSongsUrl);
    final newSongData = SongDto.toJson(title, artist);

    try {
      final response = await http.post(uri,
          headers: _headers, body: json.encode(newSongData));

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = json.decode(response.body);
        final newId = responseBody['name'] as String?;

        if (newId == null) {
          throw Exception('Failed to add song: Firebase did not return an ID.');
        }
        return Song(id: newId, title: title, artist: artist);
      } else {
        throw HttpException(
            'Failed to add song: ${response.statusCode} ${response.reasonPhrase}',
            uri: uri);
      }
    } on SocketException {
      throw Exception('Network error adding song.');
    }
  }

  @override
  Future<List<Song>> getSongs() async {
    final uri = Uri.parse(_allSongsUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);

        if (data == null) return [];
        if (data is! Map<String, dynamic>) return [];

        return data.entries
            .map((entry) {
              final id = entry.key;
              final value = entry.value;
              return value is Map<String, dynamic>
                  ? SongDto.fromJson(id, value)
                  : null;
            })
            .whereType<Song>()
            .toList();
      } else {
        throw HttpException(
            'Failed to load songs: ${response.statusCode} ${response.reasonPhrase}',
            uri: uri);
      }
    } on SocketException {
      throw Exception('Network error fetching songs.');
    }
  }

  @override
  Future<void> removeSong(String songId) async {
    final uri = Uri.parse(_songUrl(songId));

    try {
      final response = await http.delete(uri);
      if (response.statusCode >= 300) {
        throw HttpException(
            'Failed to delete song: ${response.statusCode} ${response.reasonPhrase}',
            uri: uri);
      }
    } on SocketException {
      throw Exception('Network error removing song.');
    }
  }

  @override
  Future<void> updateSong(Song song) async {
    final uri = Uri.parse(_songUrl(song.id));
    final updatedData = SongDto.toJson(song.title, song.artist);

    try {
      final response = await http.patch(uri,
          headers: _headers, body: json.encode(updatedData));

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
            'Failed to update song: ${response.statusCode} ${response.reasonPhrase}',
            uri: uri);
      }
    } on SocketException {
      throw Exception('Network error updating song.');
    }
  }
}
