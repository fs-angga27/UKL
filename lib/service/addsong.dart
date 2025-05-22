import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:ukl_revisi/model/Addsong.dart';

class AddSongService {
  Future<bool> uploadSong(AddSong song, File? thumbnail) async {
    if (thumbnail == null) return false;

    final uri = Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll(song.toFields());

    request.files.add(
      await http.MultipartFile.fromPath(
        'thumbnail',
        thumbnail.path,
        contentType: MediaType(
          'image',
          path.extension(thumbnail.path).replaceAll('.', ''),
        ),
      ),
    );

    final response = await request.send();
    return response.statusCode == 201;
  }
}