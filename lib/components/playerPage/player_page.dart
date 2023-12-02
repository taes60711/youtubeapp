import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/playerPage/PlayerSubView/download_view.dart';
import 'package:youtubeapp/components/playerPage/video_list_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/videoListState.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<VideoListCubit>();
    List<YoutubeItem> videoItems = cubit.state.videoItems;
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    VideoList selectedVideoInfo = args['selectedVideoInfo'];
      int startIndex = videoItems.indexWhere((video) => video.id == selectedVideoInfo.selectedVideo!.id);
    late YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: selectedVideoInfo.selectedVideo!.id as String,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    void videoOnChange(YoutubeItem chnagedVideo) {
      controller.load(chnagedVideo.id as String);
    }



    return Container(
        color: const Color.fromARGB(255, 27, 27, 27),
        child: BlocBuilder<VideoListCubit, VideoListState>(
          builder: ((context, state) {
            return Column(
              children: [
                YoutubePlayer(
                  controller: controller,
                  onReady: () => {
                    inspect("onReady"),
                  },
                  onEnded: (metaData) {
                    startIndex += 1;
                    controller.load(videoItems[startIndex].id as String);
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: DownloadView(
                          selectedVideo: selectedVideoInfo.selectedVideo,
                        ),
                      ),
                      VideosListView(
                        videoListInfo: selectedVideoInfo,
                        onChange: videoOnChange,
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ));
  }
}
