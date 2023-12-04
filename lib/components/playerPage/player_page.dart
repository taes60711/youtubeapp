import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/playerPage/PlayerSubView/download_view.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/channel_list_state.dart';
import 'package:youtubeapp/states/video_list_state.dart';
import 'package:youtubeapp/utilities/style_config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    int startIndex = args['selectedIndex'];
    String preRoutePath = args['preRoutePath'];
    List<YoutubeItem> ytItems = preRoutePath == '/'
        ? context.watch<VideoListCubit>().state.videoItems
        : context.watch<ChannelListCubit>().state.videoItems;
        
    late YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: ytItems[startIndex].id as String,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    void videoOnChange(int index) {
      controller.load(ytItems[index].id as String);
      startIndex = index;
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
                      selectedVideo: ytItems[startIndex],
                    ),
                  ),
                  VideosListView(
                    selectedVideoChange: videoOnChange,
                    ytItems: ytItems,
                    preRoutePath: preRoutePath,
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
