// ignore_for_file: non_constant_identifier_names

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:podcast_audio/Controller/AudioPlayerController.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AudioPlayerTest extends StatefulWidget {
  const AudioPlayerTest({Key? key}) : super(key: key);

  @override
  _AudioPlayerTestState createState() => _AudioPlayerTestState();
}

class _AudioPlayerTestState extends State<AudioPlayerTest> {
  ItemScrollController controller = ItemScrollController();

  late AudioPlayerController audiocontroller;
  bool isPlaying = false;
  double currentPostion = 0.0;
  double songduration = 0.0;
  bool showPlayer = false;
  // String lrcData =
  //     "[00:24.81] You would not believe your eyes \n [00:27.82]If ten million fireflies";
  List<String> lyricsdata = [
    '[00:24.81]You would not believe your eyes',
    '[00:27.82]If ten million fireflies',
    '[00:30.32]Lit up the world as I fell asleep',
    "[00:35.80]'Cause they'd fill the open air",
    '[00:38.30]And leave tear drops everywhere',
    "[00:40.56]You'd think me rude",
    '[00:41.81]But I would just stand and stare',
    "[00:46.06]I'd like to make myself believe",
    '[00:50.56]That planet Earth turns slowly',
    "[00:56.05]It's hard to say that I'd rather stay awake when I'm asleep",
    "[01:01.55]'Cause everything is never as it seems",
    "[01:07.05]'Cause I'd get a thousand hugs",
    '[01:10.31]From ten thousand lightning bugs',
    '[01:12.56]As they tried to teach me how to dance',
    '[01:18.31]A foxtrot above my head',
    '[01:20.81]A sock hop beneath my bed',
    '[01:23.32]The disco ball is just hanging by a thread',
    '[01:26.80](Thread, thread...)',
    "[01:28.57]I'd like to make myself believe",
    '[01:32.30]That planet Earth turns slowly',
    "[01:39.05]It's hard to say that I'd rather stay awake when I'm asleep",
    "[01:44.31]'Cause everything is never as it seems",
    '[01:48.56](When I fall asleep)',
    '[01:53.81]Leave my door open just a crack',
    '[01:56.07](Please take me away from here)',
    "[01:58.55]'Cause I feel like such an insomniac",
    '[02:01.30](Please take me away from here)',
    '[02:03.81]Why do I tire of counting sheep?',
    '[02:06.80](Please take me away from here)',
    "[02:09.05]When I'm far too tired to fall asleep",
    '[02:12.30](Ha-ha)',
    '[02:14.30]To ten million fireflies',
    "[02:16.80]I'm weird 'cause I hate goodbyes",
    '[02:19.30]I got misty eyes as they said farewell',
    '[02:23.06](Said farewell)',
    "[02:24.80]But I'll know where several are",
    '[02:27.55]If my dreams get real bizarre',
    "[02:29.81]'Cause I saved a few and I keep them in a jar",
    '[02:33.56](Jar, jar, jar...)',
    "[02:35.31]I'd like to make myself believe",
    '[02:39.06]That planet Earth turns slowly',
    "[02:45.57]It's hard to say that I'd rather stay awake when I'm asleep",
    "[02:51.05]'Cause everything is never as it seems",
    '[02:55.06](When I fall asleep)',
    "[02:57.31]I'd like to make myself believe",
    '[03:00.56]That planet Earth turns slowly',
    "[03:06.83]It's hard to say that I'd rather stay awake when I'm asleep",
    '[03:12.31]Because my dreams are bursting at the seams',
    '[03:16.00]   '
  ];

  Future<bool> initPlayer() async {
    bool res = await Future.delayed(Duration(seconds: 2), () {
      return true;
    });
    return res;
  }

  Widget slider() {
    return Slider(
        value: currentPostion,
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        max: songduration,
        min: 0.0,
        onChanged: (value) {
          audiocontroller.assetsAudioPlayer
              .seek(Duration(seconds: value.toInt()));
          currentPostion = value;
          setState(() {});
        });
  }

  // play() async {
  //   if (!isPlaying) {
  //     int result = await audioPlayer.play(
  //         "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3");
  //     if (result == 1) {
  //       isPlaying = true;
  //     }
  //   } else {
  //     audioPlayer.stop();
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    audiocontroller =
        Provider.of<AudioPlayerController>(context, listen: false);
    if (!audiocontroller.assetsAudioPlayer.isPlaying.value) {
      audiocontroller.setupAudio();
    }
    print(audiocontroller.assetsAudioPlayer.isPlaying.value);

    // AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    //   print(notification.audioId);

    //   return true; //true : handled, does not notify others listeners
    // });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print("i am called ");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: FutureBuilder(
        future: audiocontroller.lyricsParse(lyricsdata),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                audiocontroller.assetsAudioPlayer.builderRealtimePlayingInfos(
                    builder: (context, value) {
                  print(value.isPlaying);
                  currentPostion = value.currentPosition.inSeconds.toDouble();
                  songduration = value.duration.inSeconds.toDouble();
                  Map<String, dynamic> lyricsdata =
                      audiocontroller.lyricByDuration(
                          Duration(seconds: currentPostion.toInt()));
                  String lyricsLine = lyricsdata["lyrics"];
                  var lyricsindex = lyricsdata["index"];
                  if (controller.isAttached) {
                    controller.scrollTo(
                        index: lyricsindex == null ? 0 : lyricsindex,
                        duration: Duration(milliseconds: 4000),
                        curve: Curves.easeIn);
                  }

                  print(audiocontroller.lyrics.length);

                  return Column(
                    children: [
                      Container(
                        child: audiocontroller.assetsAudioPlayer
                            .builderIsPlaying(builder: (context, isPlaying) {
                          return Container(
                            width: 100,
                            height: 100,
                            child: InkWell(
                              onTap: () {
                                if (isPlaying) {
                                  audiocontroller.pause();
                                } else {
                                  audiocontroller.play();
                                }
                              },
                              child: isPlaying
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Text(audiocontroller
                                .formatedTime(currentPostion.toInt())),
                            Expanded(child: Container()),
                            Text(audiocontroller
                                .formatedTime(songduration.toInt())),
                          ],
                        ),
                      ),
                      slider(),
                      // Text(lyricsLine),
                      Container(
                        height: height * 0.55,
                        child: ScrollablePositionedList.builder(
                            itemScrollController: controller,
                            itemCount: audiocontroller.lyrics.length,
                            itemBuilder: (context, index) {
                              if (index == lyricsindex && index != null) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        audiocontroller.lyrics[index].lyric,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          audiocontroller.lyrics[index].lyric)),
                                );
                              }
                            }),
                      )

                      // ListView.builder(
                      //     controller: scrollController,
                      //     itemCount: lyrics.line.length,
                      //     itemBuilder: (context, index) {
                      //       return Container();
                      //     })
                    ],
                  );
                }),
              ],
            );
          } else {
            return Container(
              color: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      )),
    );
  }
}
