import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';
import 'package:youtubeapp/components/youtubePlayer/listView.dart';

class playerPage extends StatefulWidget {
  playerPage({super.key, this.arguments});
  final arguments;
  @override
  State<playerPage> createState() => _playerPageState();
}

class _playerPageState extends State<playerPage> {
  late Map args;
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "",
  );
  final YTService _ytService = YTService.instance;
  Map<String, bool> isLoading = {
    'download': false,
  };
  late YoutubeVideo selectedVideo;

  @override
  void initState() {
    super.initState();
    args = widget.arguments;
    selectedVideo = args["videoInfo"];
    _controller = YoutubePlayerController(
      initialVideoId: selectedVideo.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  void videoOnChange(YoutubeVideo chnagedVideo) {
    selectedVideo = chnagedVideo;
    _controller.load(selectedVideo.id);
  }

  Future<void> loadingChange(
      String loadingtype, Function fun, List<dynamic> params) async {
    setState(() => isLoading[loadingtype] = true);
    await Function.apply(fun, params);
    setState(() => isLoading[loadingtype] = false);
  }

  Widget dlerButton(
      String text, String downloadType, YoutubeVideo selectedVideo) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () async => {
        loadingChange(
            'download', _ytService.ytDownloader, [selectedVideo, downloadType]),
      },
    );
  }

  Widget dlButtonView() {
    if (isLoading['download'] as bool) {
      return const loadingWidget();
    } else {
      return Column(
        children: [
          dlerButton('Download Mp4', "mp4", selectedVideo),
          dlerButton('Download Mp3', "mp3", selectedVideo),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("playerPage : ${ModalRoute.of(context)?.settings.name}");
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 61,
            color: Colors.black,
          ),
          YoutubePlayer(
            controller: _controller,
            onReady: () => {
              print("onReady"),
            },
          ),
          dlButtonView(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("go to home"),
          ),
          VideoListView(
            videoItems: args['VideoItems'],
            inPage: ModalRoute.of(context)?.settings.name as String,
            searchKey: args['searchKey'],
            onChange: videoOnChange,
          )
        ],
      ),
    );
  }
}


