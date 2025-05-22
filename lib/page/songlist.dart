import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ukl_revisi/model/song.dart';
import 'package:ukl_revisi/page/Addsong.dart';
import 'package:ukl_revisi/page/song.dart';

class SongListPage extends StatefulWidget {
  final String playlistId;
  final String playlistName;

  const SongListPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  List<Song> _songs = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    setState(() => _isLoading = true);
    final uri = Uri.parse(
      'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/${widget.playlistId}'
      '${_searchQuery.isNotEmpty ? '?search=$_searchQuery' : ''}',
    );

    try {
      final response = await http.get(uri);
      final body = jsonDecode(response.body);

      if (body['success']) {
        setState(() {
          _songs = (body['data'] as List).map((e) => Song.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load songs: $e');
    }
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                      itemCount: _songs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final song = _songs[index];
                        return ListTile(
                          leading: Image.network(
                            'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/${song.thumbnail}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.music_note),
                          ),
                          title: Text(song.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.artist),
                              Text(
                                song.description,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite_border),
                              const SizedBox(width: 4),
                              Text('${song.likes}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => SongDetailPage(songId: song.uuid),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSongPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}