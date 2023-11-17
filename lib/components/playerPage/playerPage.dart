import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtubeapp/components/playerPage/PlayerSubView/downloadView.dart';
import 'package:youtubeapp/components/playerPage/PlayerSubView/listView.dart';
import 'package:youtubeapp/components/playerPage/playerVideoInfo_model.dart';
import 'package:youtubeapp/models/video_model.dart';

void playerPage(BuildContext context,PlayerVideoInfo videoObject) {
  late YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: "",
  );

  controller = YoutubePlayerController(
    initialVideoId: videoObject.selectedVideo.id,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  void videoOnChange(YoutubeVideo chnagedVideo) {
    videoObject.selectedVideo = chnagedVideo;
    controller.load(videoObject.selectedVideo.id);
  }

  showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 61,
                color: Colors.black,
              ),
              YoutubePlayer(
                controller: controller,
                onReady: () => {
                  print("onReady"),
                },
              ),
              DownloadView(selectedVideo: videoObject.selectedVideo),
              VideoListView(
                videoItems: videoObject.videoItems,
                routerPage: '/playerPage',
                searchKey: videoObject.searchKey,
                onChange: videoOnChange,
              )
            ],
          ),
        );
      });
}
