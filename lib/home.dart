import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtubeapp/service/YTService.dart';

import 'models/channel_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = "";
  late final YoutubePlayerController _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showControls: true,
      mute: false,
      showFullscreenButton: true,
      loop: false,
    ),
  );

  List<String> _videoIds = [
    "Iewisp9KYRw",
    "Jh4QFaPmdss",
    "fCO7f0SmrDc",
    "AKg_9dn_VmA",
    "pCh3Kp6qxo8",
    "o8XOhs2KmRM",
    "7HDeem-JaSY",
  ];

  @override
  void initState() {
    super.initState();
    _controller.loadVideoById(videoId: _videoIds[1]);
  }

  Future<List<String>> searchVideo() async {
    List<String> tmpVideos =
        await YTService.instance.searchVideosFromKeyWord(keyword: _text);
    setState(() {
      _videoIds = tmpVideos;
    });
    return tmpVideos;
  }

  @override
  Widget build(BuildContext context) {
    print("Home Start");

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          TextField(
              decoration: const InputDecoration(
                hintText: 'Enter a search term',
              ),
              onChanged: ((value) {
                setState(() {
                  _text = value;
                });
              })),
          ElevatedButton(
            child: const Text('Search'),
            onPressed: () async => {
              _controller.pauseVideo(),
              await searchVideo().then((value) {
                _controller.loadVideoById(videoId: value[1]);
              }),
            },
          ),
          ElevatedButton(
            child: const Text('play'),
            onPressed: () async => {_controller.playVideo()},
          ),
          Text(_videoIds.toString()),
          YoutubePlayer(controller: _controller)
        ],
      ),
    );
  }
}
