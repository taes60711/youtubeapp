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
  List<YoutubeVideo> _videoItems = [];
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
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                if (_searchKey.contains('https://')) {
                  print("inputed URL");
                  String tmpId = _ytService.getVideoID(_searchKey);

                  print("Result ID : ${tmpId}");
                  List<YoutubeVideo> tmpVideoItems =
                      await searchVideo(tmpId);
                  Navigator.of(context).pushNamed("/playerPage", arguments: {
                    'ID': tmpId,
                    'VideoItems': tmpVideoItems,
                    'searchKey': tmpId
                  });
                } else if (_searchKey.isNotEmpty) {
                  print("inputed KeyWord");
                  List<YoutubeVideo> tmpVideoInfo =
                      await searchVideo(_searchKey);
                  setState(() {
                    _videoItems = tmpVideoInfo;
                  });
                }
              },
            ),
          ],
        ),
        _videoItems.isNotEmpty
            ? VideoListView(
                videoItems: _videoItems,
                inPage: ModalRoute.of(context)?.settings.name as String,
                searchKey: _searchKey)
            : const Expanded(
                child: Center(
                  child: Icon(
                    Icons.subtitles_off,
                    size: 100,
                  ),
                ),
              ),
      ],
    );
  }
}
