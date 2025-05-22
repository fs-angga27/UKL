import 'package:flutter/material.dart';
import 'package:ukl_revisi/model/songDetail.dart';
import 'package:ukl_revisi/service/songdetail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class SongDetailPage extends StatefulWidget {
  final String songId;
  const SongDetailPage({super.key, required this.songId});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  late Future<SongDetail> _songFuture;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _songFuture = SongDetailService.fetchSongDetail(widget.songId);
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initYoutubeController(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Song Detail")),
      body: FutureBuilder<SongDetail>(
        future: _songFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final song = snapshot.data!;
          if (_youtubeController == null) {
            _initYoutubeController(song.source);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(song.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(song.artist, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),

                if (_youtubeController != null)
                  YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                  ),

                const SizedBox(height: 16),
                Text("Description", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(song.description),
                const Divider(height: 30),
                Text("Comments", style: const TextStyle(fontWeight: FontWeight.bold)),
                ...song.comments.map((c) => ListTile(
                      title: Text(c.creator),
                      subtitle: Text(c.commentText),
                      trailing: Text(c.createdAt),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}