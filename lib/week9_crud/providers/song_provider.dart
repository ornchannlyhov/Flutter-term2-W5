// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../data/repositories/song_repository.dart';
import '../utils/async_value.dart';

class SongProvider extends ChangeNotifier {
  final SongRepository _repository;
  AsyncValue<List<Song>> songsState = const AsyncValue.loading();

  SongProvider(this._repository) {
    fetchSongs();
  }

  bool get isLoading => songsState.isLoading;
  bool get hasData => songsState.hasData;
  bool get hasError => songsState.hasError;
  List<Song>? get songs => songsState.data;
  Object? get error => songsState.error;

  Future<void> fetchSongs() async {
    _updateState(const AsyncValue.loading());
    try {
      final songList = await _repository.getSongs();
      _updateState(AsyncValue.success(_sortedList(songList)));
    } catch (e) {
      _updateState(AsyncValue.error(e));
    }
  }

  Future<void> addSong(String title, String artist) async {
    try {
      final newSong = await _repository.addSong(title: title, artist: artist);
      final updatedList = [...?songsState.data, newSong];
      _updateState(AsyncValue.success(_sortedList(updatedList)));
    } catch (e) {
      print("Error adding song: $e");
      rethrow;
    }
  }

  Future<void> removeSong(Song songToRemove) async {
    if (!hasData) return;

    final originalList = List<Song>.from(songsState.data!);
    final updatedList =
        originalList.where((s) => s.id != songToRemove.id).toList();
    _updateState(AsyncValue.success(updatedList));

    try {
      await _repository.removeSong(songToRemove.id);
    } catch (e) {
      print("Error removing song, restoring previous state: $e");
      _updateState(AsyncValue.success(_sortedList(originalList)));
      rethrow;
    }
  }

  Future<void> updateSong(Song songToUpdate) async {
    if (!hasData) return;

    try {
      await _repository.updateSong(songToUpdate);
      final updatedList = songsState.data!.map((song) {
        return song.id == songToUpdate.id ? songToUpdate : song;
      }).toList();

      _updateState(AsyncValue.success(_sortedList(updatedList)));
    } catch (e) {
      print("Error updating song: $e");
      rethrow;
    }
  }

  void _updateState(AsyncValue<List<Song>> newState) {
    songsState = newState;
    notifyListeners();
  }

  List<Song> _sortedList(List<Song> songs) {
    songs.sort((a, b) {
      final artistCompare =
          a.artist.toLowerCase().compareTo(b.artist.toLowerCase());
      return artistCompare != 0
          ? artistCompare
          : a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return songs;
  }
}
