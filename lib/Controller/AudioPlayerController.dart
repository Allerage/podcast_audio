import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:podcast_audio/Model/LyricsModel.dart';

class AudioPlayerController with ChangeNotifier {
  List<Lyric> lyrics = [];
  bool hasAdded = false;
  bool isInitialized = false;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  int secondsFromString(String time) {
    //"01:44.31"
    // min:sec.milli

    List<String> secondsdata = time.split(":");
    print(secondsdata);

    int minutes = int.parse(secondsdata[0]);
    int seconds = int.parse(secondsdata[1].split(".")[0]);

    int totalSeconds = (minutes * 60) + seconds;

    print(totalSeconds);
    return 0;
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

  void setupAudio() {
    assetsAudioPlayer.open(
        Playlist(audios: [
          Audio("assets/audios/test.mp3"),
        ]),
        showNotification: false,
        autoStart: false);
    isInitialized = true;
  }

  play() async {
    if (assetsAudioPlayer.isPlaying.value) {
      setupAudio();
    }
    assetsAudioPlayer.showNotification = true;

    await assetsAudioPlayer.play();
  }

  pause() async {
    assetsAudioPlayer.showNotification = false;
    await assetsAudioPlayer.pause();
  }

  stop() async {
    assetsAudioPlayer.showNotification = false;
    await assetsAudioPlayer.stop();
  }

  Future<bool> lyricsParse(List<String> lrc) async {
    List<String> lrclines = lrc;
    List<String> line = [];
    List<Duration> timestamps = [];
    if (lrclines.isNotEmpty) {
      for (int i = 0; i < lrclines.length; i++) {
        final regex = RegExp(r'^\[([0-9]+):([0-9]+)\.([0-9]+)\](.*)$');
        final match = regex.firstMatch(lrclines[i].trim());
        if (match != null) {
          final everything = match.group(0);
          final minutes = match.group(1);
          final seconds = match.group(2);
          final fraction = match.group(3);
          final words = match.group(4);
          line.add(words!);
          timestamps.add(lyricTimeToDuration(minutes!, seconds!));
        }
      }
    }
    print(line);
    print(timestamps);
    if (!hasAdded) {
      for (int i = 0; i < line.length; i++) {
        print(i + 1 == line.length);
        lyrics.add(Lyric(line[i],
            startTime: timestamps[i],
            endTime: i + 1 == line.length
                ? Duration(hours: 200)
                : timestamps[i + 1]));
      }
      hasAdded = true;
    }

    return true;

    // lrc = lrc.replaceAll("\r", "");
    // RegExp reg = RegExp(r"""\[(.*?):(.*?)\](.*?)\n""");
    // late Iterable<Match> matches;
    // try {
    //   matches = reg.allMatches(lrc);
    // } catch (e) {

    //   print(e.toString());
    // }

    // List list = matches.toList();
    // if (list != null) {
    //   for (int i = 0; i < list.length; i++) {
    //     var temp = list[i];
    //     var title = list[i][3];
    //     lyrics.add(Lyric(title,
    //         startTime: lyricTimeToDuration("${temp[1]}:${temp[2]}"),
    //         endTime: Duration()));
    //   }
    // }

    // lyrics.removeWhere((lyric) => lyric.lyric.trim().isEmpty);
    // for (int i = 0; i < lyrics.length - 1; i++) {
    //   lyrics[i].endTime = lyrics[i + 1].startTime;
    // }

    // print(lyrics);
  }

  Duration lyricTimeToDuration(String minutes, String seconds) {
    return Duration(minutes: int.parse(minutes), seconds: int.parse(seconds));
  }

  lyricByDuration(Duration curDuration) {
    print(curDuration);
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= lyrics[i].startTime &&
          curDuration < lyrics[i].endTime) {
        return {"index": i, "lyrics": lyrics[i].lyric};
      }
    }
    return {"index": null, "lyrics": ""};
  }
}
