import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:youtubeapp/service/yt_service.dart';
import 'models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IsLoadAndMessageController {
  bool videoList;
  bool download;
  String isDlSuc;
  IsLoadAndMessageController(this.videoList, this.download, this.isDlSuc);
  IsLoadAndMessageController.initialize()
      : videoList = false,
        download = false,
        isDlSuc = "";
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = "";
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'Nt1bCK9Aj1k',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );
  List<YoutubeVideo> _videoInfo = [];
  YoutubeVideo? selectedVideo;
  final IsLoadAndMessageController _loadingController =
      IsLoadAndMessageController.initialize();
  late final ScrollController _scrollController = ScrollController();
  final YTService _ytService = YTService.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<List<YoutubeVideo>> searchVideo() async {
    List<YoutubeVideo> tmpVideos =
        await _ytService.searchVideosFromKeyWord(keyword: _text);
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

  Widget dlerButton(String text, String downloadType) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () async => {
        setState(() => _loadingController.download = true),
        _loadingController.isDlSuc =
            await _ytService.ytDownloader(selectedVideo!, downloadType),
        setState(() {
          _loadingController.download = false;
        }),
      },
    );
  }

  Widget dlMessage(String isDlSuc) {
    if (isDlSuc == "sucessfull") {
      return const Text("Dl SuccessFully");
    } else if (isDlSuc == "fail") {
      return const Text("Dl Failed");
    } else {
      return const SizedBox();
    }
  }

  Widget dlButtonView() {
    if (selectedVideo != null) {
      if (!_loadingController.download) {
        return Column(
          children: [
            dlerButton('Download Mp4', "mp4"),
            dlerButton('Download Mp3', "mp3"),
            dlMessage(_loadingController.isDlSuc),
          ],
        );
      } else {
        return loadingWidget();
      }
    } else {
      return const SizedBox();
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
                _loadingController.isDlSuc = "";
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
        Container(
          height: 61,
          color: Colors.black,
        ),
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
        dlButtonView(),
        videoListView(_loadingController.videoList),
      ],
    ));
  }
}
