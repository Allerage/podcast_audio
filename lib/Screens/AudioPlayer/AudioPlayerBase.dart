import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:podcast_audio/Controller/HomePageController.dart';
import 'package:podcast_audio/Model/SongModel.dart';
import 'package:podcast_audio/Utils/decoration.dart';
import 'package:provider/provider.dart';

class DarkAudioPlayer extends StatefulWidget {
  SongData song;
  int index;
  DarkAudioPlayer({Key? key, required this.song, required this.index})
      : super(key: key);

  @override
  _DarkAudioPlayerState createState() => _DarkAudioPlayerState();
}

class _DarkAudioPlayerState extends State<DarkAudioPlayer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  double position = 0;
  bool showGlow = true;
  double currentPostion = 0.0;
  double songduration = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    HomePageController audio =
        Provider.of<HomePageController>(context, listen: false);
    if (!(audio.playingSong == widget.song.songPath)) {
      audio.setupAudio(widget.song.songPath);
    }
    _controller = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Provider.of<HomePageController>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black87,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    controller.back();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.black87,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                spreadRadius: 1),
                            BoxShadow(
                                color: showGlow ? Colors.white : Colors.black,
                                offset: Offset(-1, -1),
                                blurRadius: 9,
                                spreadRadius: 1)
                          ]),
                      child: Stack(alignment: Alignment.center, children: [
                        ClipOval(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                border: Border.all(color: Colors.green)),
                          ),
                        ),
                        Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                height: height * 0.4,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Lottie.asset("assets/animations/panda.json",
                          controller: _controller, onLoaded: (duration) {
                        _controller.duration = duration.duration;
                        if (controller.assetsAudioPlayer.isPlaying.value) {
                          _controller.forward();
                          _controller.repeat();
                        }
                      }),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(widget.song.songName,
                    style: CustomDecoration.Boogaloo(
                        fontsize: 25, fontcolor: Colors.green)),
              ),
              controller.assetsAudioPlayer.builderRealtimePlayingInfos(
                  builder: (context, value) {
                currentPostion = value.currentPosition.inSeconds.toDouble();
                songduration = value.duration.inSeconds.toDouble();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Text(controller.formatedTime(currentPostion.toInt()),
                              style: CustomDecoration.Boogaloo(
                                  fontsize: 14, fontcolor: Colors.green)),
                          Expanded(child: Container()),
                          Text(controller.formatedTime(songduration.toInt()),
                              style: CustomDecoration.Boogaloo(
                                  fontsize: 14, fontcolor: Colors.green)),
                        ],
                      ),
                    ),
                    Slider(
                        value: currentPostion,
                        min: 0.0,
                        max: songduration,
                        activeColor: Colors.green,
                        inactiveColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            controller.assetsAudioPlayer
                                .seek(Duration(seconds: value.toInt()));
                            currentPostion = value;
                          });
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.index == 0) {
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DarkAudioPlayer(
                                          index: widget.index - 1,
                                          song: controller
                                              .songs[widget.index - 1],
                                        )),
                              );
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Colors.black87,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(4, 4),
                                      blurRadius: 10,
                                      spreadRadius: 1),
                                  BoxShadow(
                                      color: showGlow
                                          ? Colors.white
                                          : Colors.black,
                                      offset: Offset(-1, -1),
                                      blurRadius: 9,
                                      spreadRadius: 1)
                                ]),
                            child:
                                Stack(alignment: Alignment.center, children: [
                              ClipOval(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.green)),
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_sharp,
                                color: Colors.white,
                              )
                            ]),
                          ),
                        ),
                        controller.assetsAudioPlayer.builderIsPlaying(
                            builder: (context, isPlaying) {
                          return InkWell(
                            onTap: () {
                              if (isPlaying) {
                                controller.pause();
                                _controller.stop();
                              } else {
                                controller.play(widget.song.songPath);
                                _controller.forward();
                                _controller.repeat();
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black87,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(4, 4),
                                        blurRadius: 10,
                                        spreadRadius: 1),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(-1, -1),
                                        blurRadius: 9,
                                        spreadRadius: 1)
                                  ]),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                ClipOval(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        border:
                                            Border.all(color: Colors.green)),
                                  ),
                                ),
                                Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                )
                              ]),
                            ),
                          );
                        }),
                        InkWell(
                          onTap: () {
                            if (widget.index == controller.songs.length - 1) {
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DarkAudioPlayer(
                                          index: widget.index + 1,
                                          song: controller
                                              .songs[widget.index + 1],
                                        )),
                              );
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Colors.black87,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(4, 4),
                                      blurRadius: 10,
                                      spreadRadius: 1),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-1, -1),
                                      blurRadius: 9,
                                      spreadRadius: 1)
                                ]),
                            child:
                                Stack(alignment: Alignment.center, children: [
                              ClipOval(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.green)),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_sharp,
                                color: Colors.white,
                              )
                            ]),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
