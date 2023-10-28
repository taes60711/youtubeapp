import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtubeapp/service/yt_service.dart';
import 'models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  List<YoutubeVideo> _videoInfo = [];
  YoutubeVideo? selectedVideo;
  final IsLoadController _loadingController = IsLoadController.initialize();
  late final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  Future<List<YoutubeVideo>> searchVideo() async {
    List<YoutubeVideo> tmpVideos =
        await YTService.instance.searchVideosFromKeyWord(keyword: _text);
    return tmpVideos;
  }

  Widget loadingWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          backgroundColor: Colors.black26,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget downloaderButton(String text, String downloadType) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () async => {
        setState(() => _loadingController.download = true),
        await YTService.instance.ytDownloader(selectedVideo!, downloadType),
        setState(() => _loadingController.download = false),
      },
    );
  }

  Widget downloadButton() {
    if (selectedVideo != null) {
      if (!_loadingController.download) {
        return Column(
          children: [
            downloaderButton('Download Mp4', "mp4"),
            downloaderButton('Download Mp3', "mp3"),
          ],
        );
      } else {
        return loadingWidget();
      }
    } else {
      return const Text("");
    }
  }

  Widget listItem(YoutubeVideo videoInfo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: videoInfo.kind == 'video'
          ? ElevatedButton(
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
                      image: NetworkImage(videoInfo.thumbnailUrl),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videoInfo.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(videoInfo.channelTitle)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                setState(() => selectedVideo = videoInfo);
                _controller.load(videoInfo.id);
              },
            )
          : SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 130,
                    child: Center(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(videoInfo.thumbnailUrl),
                      ),
                    )),
                  ),
                  Text(videoInfo.channelTitle)
                ],
              ),
            ),
    );
  }

  Widget videoListView(bool isLoading) {
    if (_videoInfo.isEmpty && isLoading) {
      return loadingWidget();
    } else {
      return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        final before = scrollNotification.metrics.extentBefore;
                        final max = scrollNotification.metrics.maxScrollExtent;
                        if (before == max && !_loadingController.videoList) {
                          setState(() => _loadingController.videoList = true);
                          searchVideo().then((value) {
                            setState(() {
                              _videoInfo.addAll(value);
                              _loadingController.videoList = false;
                            });
                          });
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _videoInfo.length,
                      itemBuilder: (context, index) {
                        if (index == _videoInfo.length - 1) {
                          return Column(
                            children: [
                              listItem(_videoInfo[index]),
                              _loadingController.videoList ? loadingWidget() : Container()
                            ],
                          );
                        } else {
                          return listItem(_videoInfo[index]);
                        }
                      },
                    ),
                  ),
                ),
              ],
            )),
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
                setState(() => _loadingController.videoList = true),
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
