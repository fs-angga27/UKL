// services/playlist_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukl_revisi/model/song_playlist.dart';

class PlaylistService {
  static Future<List<Playlist>> fetchPlaylists() async {
    final response = await http.get(
      Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((e) => Playlist.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load playlists');
      }
    } else {
      throw Exception('Network error');
    }
  } 
}