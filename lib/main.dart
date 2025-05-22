import 'package:flutter/material.dart';
import 'package:ukl_revisi/page/login.dart';
import 'package:ukl_revisi/page/playlist.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Apply SSL bypass globally
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/Playlist': (context) => PlaylistPage(),
      },
    ),
  );
}
