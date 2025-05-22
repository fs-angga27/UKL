class Comment {
  final String commentText;
  final String creator;
  final String createdAt;

  Comment({required this.commentText, required this.creator, required this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentText: json['comment_text'],
    creator: json['creator'],
    createdAt: json['createdAt'],
  );
}

class SongDetail {
  final String uuid;
  final String title;
  final String artist;
  final String description;
  final String source;
  final String thumbnail;
  final int likes;
  final List<Comment> comments;

  SongDetail({
    required this.uuid,
    required this.title,
    required this.artist,
    required this.description,
    required this.source,
    required this.thumbnail,
    required this.likes,
    required this.comments,
  });

  factory SongDetail.fromJson(Map<String, dynamic> json) {
    return SongDetail(
      uuid: json['uuid'],
      title: json['title'],
      artist: json['artist'],
      description: json['description'],
      source: json['source'],
      thumbnail: json['thumbnail'],
      likes: json['likes'],
      comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
    );
  }
}