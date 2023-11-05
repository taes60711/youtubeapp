import 'package:flutter/material.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';
import 'package:youtubeapp/youtubePlayer/listView.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _searchKey = "";
  final YTService _ytService = YTService.instance;
  List<YoutubeVideo> _videoInfo = [];
  Future<List<YoutubeVideo>> searchVideo(String searchKey) async {
    List<YoutubeVideo> tmpVideos =
        await _ytService.searchVideosFromKeyWord(keyword: searchKey);
    return tmpVideos;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 61,
          color: Colors.black,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed("/playerPage", arguments: {'ID': "5Ags3ZeoLYY"});
          },
          child: const Text("go to playerPage"),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter a search',
                    border: InputBorder.none,
                  ),
                  onChanged: ((value) {
                    _searchKey = value;
                  })),
            ),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () async {
                if (_searchKey.contains('https://')) {
                  String tmpId = _ytService.getVideoID(_searchKey);
                  print("Result ID : ${tmpId}");
                  Navigator.of(context)
                      .pushNamed("/playerPage", arguments: {'ID': tmpId});
                } else if (_searchKey.isNotEmpty) {
                  print('search');
                  var tmpVideoInfo = await searchVideo(_searchKey);
                  setState(() {
                    _videoInfo = tmpVideoInfo;
                  });
                }
              },
            ),
          ],
        ),
        VideoListView(
          videoInfo: _videoInfo,
        ),
      ],
    );
  }
}
