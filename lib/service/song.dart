import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukl_revisi/model/song.dart';

class SongService {
  static Future<List<Song>> fetchSongs(String playlistId, {String? search}) async {
    final uri = Uri.parse(
      'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/$playlistId${search != null ? "?search=$search" : ""}',
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => Song.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }
}