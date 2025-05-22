class Song {
  final String uuid;
  final String title;
  final String artist;
  final String description;
  final String thumbnail;
  final int likes;

  Song({
    required this.uuid,
    required this.title,
    required this.artist,
    required this.description,
    required this.thumbnail,
    required this.likes,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      uuid: json['uuid'],
      title: json['title'],
      artist: json['artist'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      likes: json['likes'],
    );
  }
}