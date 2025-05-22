class AddSong {
  final String title;
  final String artist;
  final String description;
  final String source;

  AddSong({
    required this.title,
    required this.artist,
    required this.description,
    required this.source,
  });

  Map<String, String> toFields() {
    return {
      'title': title,
      'artist': artist,
      'description': description,
      'source': source,
    };
  }
}