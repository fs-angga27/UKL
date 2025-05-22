// models/playlist.dart
class Playlist {
  final String uuid;
  final String playlistName;
  final int songCount;

  Playlist({
    required this.uuid,
    required this.playlistName,
    required this.songCount,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      uuid: json['uuid'],
      playlistName: json['playlist_name'],
      songCount: json['song_count'],
    );
  }
}