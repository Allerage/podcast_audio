import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:podcast_audio/Controller/HomePageController.dart';
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
                          child: Container(
                            height: 40,
                            color: Colors.white,
                            child: Text(
                              song,
                              style: CustomDecoration.Boogaloo(
                                  fontsize: 12, fontcolor: Colors.green),
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
                        "Allow Storage Access",
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
