import 'package:flutter/material.dart';
import 'package:podcast_audio/Controller/AudioPlayerController.dart';
import 'package:podcast_audio/Screens/AudioPlayer/AudioPlayerScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AudioPlayerController())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AudioPlayerTest(),
        ));
  }
}
