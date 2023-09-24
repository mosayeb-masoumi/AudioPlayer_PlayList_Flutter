import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_player_example/playlist/controls_list.dart';
import 'package:just_audio_player_example/playlist/media_meta_data.dart';
import 'package:just_audio_player_example/simple_play_pause/position_data.dart';
import 'package:rxdart/rxdart.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _HomePageState();
}

class _HomePageState extends State<PlayListPage> {
  late AudioPlayer _audioPlayer;

  //to setup list
  final _playList = ConcatenatingAudioSource(children: [
    AudioSource.uri(
        // from asset
        Uri.parse("asset:///assets/audio/nature.mp3"), // carefully insert the route (asset:///assets/...)
        tag: MediaItem(
            id: "0",
            title: "shabhaye masti",
            artist: "hiedeh",
            artUri: Uri.parse(
                "https://via.placeholder.com/300x300"))),
    AudioSource.uri(
        // from URL
        Uri.parse(
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
        tag: MediaItem(
            id: "2",
            title: "speech",
            artist: "unknown",
            artUri: Uri.parse(
                "https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg"))),
  ]);

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playList);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            color: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF144771), Color(0xFF071A2C)])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<SequenceState?>(
                  stream: _audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metaData = state!.currentSource!.tag as MediaItem;
                    return MediaMetaData(
                        imageUrl: metaData.artUri.toString(),
                        title: metaData.title ?? "",
                        artist: metaData.artist ?? "");
                  }),

              const SizedBox(
                height: 20,
              ),
              // to show progressbar
              StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.red,
                      thumbColor: Colors.red,
                      timeLabelTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    );
                  }),

              const SizedBox(
                height: 20,
              ),

              // to show play pause button
              ControlsList(audioPlayer: _audioPlayer)
            ],
          ),
        ));
  }
}
