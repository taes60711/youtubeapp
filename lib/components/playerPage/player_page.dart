import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/playerPage/PlayerSubView/download_view.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/video_list_state.dart';
import 'package:youtubeapp/utilities/style_config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    YoutubeItem selectedVideo = args['selectedVideo'];
    int startIndex = args['selectedIndex'];
    late YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: selectedVideo.id as String,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    List<YoutubeItem> ytItems =
        context.watch<VideoListCubit>().state.videoItems;

    void videoOnChange(YoutubeItem chnagedVideo) {
      controller.load(chnagedVideo.id as String);
    }

    return SafeArea(
      child: Container(
        color: normalBgColor,
        child: Column(
          children: [
            YoutubePlayer(
              controller: controller,
              onReady: () => {},
              onEnded: (metaData) {
                startIndex += 1;
                controller.load(ytItems[startIndex].id as String);
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: DownloadView(
                      selectedVideo: selectedVideo,
                    ),
                  ),
                  VideosListView(
                    selectedVideoChange: videoOnChange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
