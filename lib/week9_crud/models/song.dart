class Song {
  final String id;
  final String title;
  final String artist;

  const Song({required this.id, required this.title, required this.artist});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, artist: $artist}';
  }

  // copy with potentially updated fields
  Song copyWith({
    String? id,
    String? title,
    String? artist,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
    );
  }
}
