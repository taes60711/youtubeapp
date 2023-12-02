import 'package:youtubeapp/models/video_model.dart';

class VideoList {
  YoutubeItem? selectedVideo;
  String searchKey;
  String routerPage;

  VideoList({
    this.selectedVideo,
    required this.searchKey,
    required this.routerPage,
  });

  factory VideoList.fromMap(Map<String, dynamic> map) {
    return VideoList(
      selectedVideo: map['selectedVideo'],
      searchKey: map['searchKey'],
      routerPage: map['routerPage'],
    );
  }
}
