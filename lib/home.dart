import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtubeapp/service/YTService.dart';

import 'models/channel_model.dart';
import 'models/video_model.dart';

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

  List<Video> _videoInfo = [];

  @override
  void initState() {
    super.initState();
    _controller.loadVideoById(videoId: _videoIds[1]);
  }

  Future<List<Video>> searchVideo() async {
    List<Video> tmpVideos =
        await YTService.instance.searchVideosFromKeyWord(keyword: _text);
    return tmpVideos;
  }

  @override
  Widget build(BuildContext context) {
    print("Home Start");
    return (Column(
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
            await searchVideo().then((value) {
              setState(() {
                _videoInfo = value;
              });
            }),
          },
        ),
        YoutubePlayer(controller: _controller),
        Expanded(
            child: ListView.builder(
          itemCount: _videoInfo.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.network(_videoInfo[index].thumbnailUrl),
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text(_videoInfo[index].title),
                    onPressed: () => {
                      _controller.loadVideoById(videoId: _videoInfo[index].id)
                    },
                  ),
                )
              ],
            );
          },
        ))
      ],
    ));
  }
}
