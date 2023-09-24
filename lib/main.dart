import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_player_example/background_play_list/background_play_list_page.dart';
import 'package:just_audio_player_example/playlist/play_list_page.dart';
import 'package:just_audio_player_example/simple_play_pause/home_page.dart';


// void main() {
//   runApp(const MyApp());
// }



//source : https://www.youtube.com/watch?v=DIqB8qEZW1U&t=1s

// to be able to play in background
Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: "com.ryanheise.bg_demo.channel.audio",
    androidNotificationChannelName: "Audio playback",
    androidNotificationOngoing: true
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomePage(),
      // home: const PlayListPage(),
      home: const BackGroundPlayListPage(),
    );
  }
}


