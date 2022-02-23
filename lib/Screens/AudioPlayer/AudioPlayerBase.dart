import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:podcast_audio/Utils/decoration.dart';

class DarkAudioPlayer extends StatefulWidget {
  const DarkAudioPlayer({Key? key}) : super(key: key);

  @override
  _DarkAudioPlayerState createState() => _DarkAudioPlayerState();
}

class _DarkAudioPlayerState extends State<DarkAudioPlayer> {
  double position = 0;
  bool showGlow = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.4,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      color: Colors.white,
                      width: 180,
                      height: 180,
                      child: Lottie.asset("assets/animations/MusicDisc.json"),
                    ),
                  ),
                ),
              ),
              Text("Song Name",
                  style: CustomDecoration.Boogaloo(
                      fontsize: 25, fontcolor: Colors.green)),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Text("0:00",
                        style: CustomDecoration.Boogaloo(
                            fontsize: 14, fontcolor: Colors.green)),
                    Expanded(child: Container()),
                    Text("1:00",
                        style: CustomDecoration.Boogaloo(
                            fontsize: 14, fontcolor: Colors.green)),
                  ],
                ),
              ),
              Slider(
                  value: position,
                  min: 0.0,
                  max: 100.0,
                  activeColor: Colors.green,
                  inactiveColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      position = value;
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        showGlow = false;
                      });
                      Future.delayed(Duration(milliseconds: 80), () {
                        setState(() {
                          showGlow = true;
                        });
                      });
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
                                color: showGlow ? Colors.white : Colors.black,
                                offset: Offset(-1, -1),
                                blurRadius: 9,
                                spreadRadius: 1)
                          ]),
                      child: Stack(alignment: Alignment.center, children: [
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
                  Container(
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
                    child: Stack(alignment: Alignment.center, children: [
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
                        Icons.play_arrow,
                        color: Colors.white,
                      )
                    ]),
                  ),
                  Container(
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
                    child: Stack(alignment: Alignment.center, children: [
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
