import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast_audio/Controller/HomePageController.dart';
import 'package:podcast_audio/Screens/AudioPlayer/AudioPlayerBase.dart';
import 'package:podcast_audio/Utils/decoration.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<HomePageController>(context, listen: false).getSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomePageController homepageController = Provider.of<HomePageController>(
      context,
    );
    return Scaffold(
      backgroundColor: Colors.black87,
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  child: LottieBuilder.asset("assets/animations/panda.json"),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "DarkPlayer",
          style:
              CustomDecoration.Boogaloo(fontsize: 25, fontcolor: Colors.white),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Permission.storage.status,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              PermissionStatus status = snapshot.data as PermissionStatus;
              if (status.isGranted) {
                if (homepageController.hasLoadedSongs) {
                  return ListView.builder(
                      itemCount: homepageController.songs.length,
                      itemBuilder: (context, index) {
                        String song = homepageController.songs[index].songName;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DarkAudioPlayer(
                                          song: homepageController.songs[index],
                                        )),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                height: 60,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.music_note),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            song,
                                            style: CustomDecoration.Boogaloo(
                                                fontsize: 12,
                                                fontcolor: Colors.green),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (homepageController
                                            .songs[index].songPath ==
                                        homepageController.playingSong) ...[
                                      LottieBuilder.asset(
                                        "assets/animations/Speaker.json",
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: InkWell(
                    onTap: () {
                      Provider.of<HomePageController>(context, listen: false)
                          .getSongs();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.green,
                      width: 150,
                      height: 50,
                      child: Text(
                        "show songs",
                        style: CustomDecoration.Boogaloo(
                            fontsize: 18, fontcolor: Colors.white),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
