import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast_audio/Model/SongModel.dart';

class HomePageController with ChangeNotifier {
  bool hasLoadedSongs = false;
  List<SongData> _songs = [];
  List<SongData> get songs => _songs;
  getSongs() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (status.isGranted) {
      Directory dir = Directory('/storage/emulated/0/');
      String mp3Path = dir.toString();
      print(mp3Path);
      List<FileSystemEntity> _files;

      _files = dir.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity entity in _files) {
        String path = entity.path;
        print(path);

        if (path.endsWith('.mp3') &&
            !path.contains("Android") &&
            !path.contains("sound_recorder")) {
          _songs.add(SongData(
              songName: path.split("/").last.split(".").first,
              songPath: entity.path));
        }
      }
      print(_songs);
      print(_songs.length);
      hasLoadedSongs = true;
      return true;
    } else {
      return false;
    }
  }
}
