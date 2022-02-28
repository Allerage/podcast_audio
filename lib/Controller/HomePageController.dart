import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast_audio/Model/SongModel.dart';

class HomePageController with ChangeNotifier {
  bool hasLoadedSongs = false;
  List<SongData> _songs = [];
  String playingSong = "";
  List<SongData> get songs => _songs;
  bool isInitialized = false;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  void setupAudio(String filepath) {
    assetsAudioPlayer.open(Playlist(audios: [Audio.file(filepath)]),
        showNotification: false, autoStart: false);
    isInitialized = true;
    playingSong = filepath;
  }

  play(String filepath) async {
    if (assetsAudioPlayer.isPlaying.value) {
      setupAudio(filepath);
    }
    assetsAudioPlayer.showNotification = true;

    await assetsAudioPlayer.play();
    notifyListeners();
  }

  pause() async {
    assetsAudioPlayer.showNotification = false;
    await assetsAudioPlayer.pause();
  }

  stop() async {
    assetsAudioPlayer.showNotification = false;
    await assetsAudioPlayer.stop();
  }

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + " : " + getParsedTime(sec.toString());

    return parsedTime;
  }

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
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
