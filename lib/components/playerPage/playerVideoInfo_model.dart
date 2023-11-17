import 'package:youtubeapp/models/video_model.dart';

class PlayerVideoInfo {
  YoutubeVideo selectedVideo;
  List<YoutubeVideo> videoItems;
  String searchKey;

  PlayerVideoInfo({
    required this.selectedVideo,
    required this.videoItems,
    required this.searchKey,
  });

    factory PlayerVideoInfo.fromMap(Map<String, dynamic> map) {
    return PlayerVideoInfo(
      selectedVideo: map['selectedVideo'],
      videoItems: map['videoItems'],
      searchKey: map['searchKey'],
    );
  }
}
