import 'package:youtubeapp/models/video_model.dart';

class VideoList {
  YoutubeVideo? selectedVideo;
  List<YoutubeVideo> videoItems;
  String searchKey;
  String? routerPage;

  VideoList({
    this.selectedVideo,
    required this.videoItems,
    required this.searchKey,
    this.routerPage,
  });

  factory VideoList.fromMap(Map<String, dynamic> map) {
    return VideoList(
      selectedVideo: map['selectedVideo'],
      videoItems: map['videoItems'],
      searchKey: map['searchKey'],
      routerPage: map['routerPage'],
    );
  }
}
