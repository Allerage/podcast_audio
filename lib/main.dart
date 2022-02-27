import 'package:flutter/material.dart';
import 'package:podcast_audio/Controller/AudioPlayerController.dart';
import 'package:podcast_audio/Controller/HomePageController.dart';

import 'package:podcast_audio/Screens/Home/HomePage.dart';

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
          ChangeNotifierProvider(create: (context) => AudioPlayerController()),
          ChangeNotifierProvider(create: (context) => HomePageController())
        ],
        child: MaterialApp(
          title: 'Dark Audio Player',
          theme: ThemeData(
            primarySwatch: Colors.green,
            backgroundColor: Colors.black87,
          ),
          home: const HomePage(),
        ));
  }
}
