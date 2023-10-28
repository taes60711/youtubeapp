import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtubeapp/service/yt_service.dart';
import 'models/video_model.dart';

class IsLoadController {
  bool videoList;
  bool download;
  IsLoadController(this.videoList, this.download);
  IsLoadController.initialize()
      : videoList = false,
        download = false;
}

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
      playsInline: false,
    ),
  );
  final List<String> _videoIds = [
    "tc96cx9uvAU",
    "D7dzSapaIS4",
  ];
  List<YoutubeVideo> _videoInfo = [];
  YoutubeVideo? selectedVideo;
  final IsLoadController _loadingController = IsLoadController.initialize();

  @override
  void initState() {
    super.initState();
    _controller.loadVideoById(videoId: _videoIds[0]);
  }

  Future<List<YoutubeVideo>> searchVideo() async {
    List<YoutubeVideo> tmpVideos =
        await YTService.instance.searchVideosFromKeyWord(keyword: _text);
    return tmpVideos;
  }

  Widget downloadButton() {
    if (selectedVideo != null) {
      if (!_loadingController.download) {
        return Column(
          children: [
            ElevatedButton(
              child: const Text('Download Mp4'),
              onPressed: () async => {
                setState(() {
                  _loadingController.download = true;
                }),
                await YTService.instance.ytDownloader(selectedVideo!, "mp4"),
                setState(() {
                  _loadingController.download = false;
                }),
              },
            ),
            ElevatedButton(
              child: const Text('Download Mp3'),
              onPressed: () async => {
                setState(() {
                  _loadingController.download = true;
                }),
                await YTService.instance.ytDownloader(selectedVideo!, "mp3"),
                setState(() {
                  _loadingController.download = false;
                }),
              },
            ),
          ],
        );
      } else {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              backgroundColor: Colors.black26,
              color: Colors.black26,
            ),
          ),
        );
      }
    } else {
      return const Text("");
    }
  }

  Widget videoListView(bool isLoading) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            strokeWidth: 8,
            backgroundColor: Colors.black26,
            color: Colors.black26,
          ),
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemCount: _videoInfo.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 80,
                          width: 130,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(_videoInfo[index].thumbnailUrl),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _videoInfo[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(_videoInfo[index].channelTitle),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      selectedVideo = _videoInfo[index];
                    });
                    _controller.loadVideoById(videoId: _videoInfo[index].id);
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter a search term',
                    border: InputBorder.none,
                  ),
                  onChanged: ((value) {
                    setState(() {
                      _text = value;
                    });
                  })),
            ),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () async => {
                setState(() {
                  _loadingController.videoList = true;
                }),
                await searchVideo().then((value) {
                  setState(() {
                    _videoInfo = value;
                    _loadingController.videoList = false;
                  });
                }),
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: YoutubePlayer(controller: _controller),
        ),
        downloadButton(),
        videoListView(_loadingController.videoList),
      ],
    ));
  }
}
