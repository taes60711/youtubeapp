// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtubeapp/components/playerPage/PlayerSubView/downloadView.dart';
// import 'package:youtubeapp/components/playerPage/PlayerSubView/listView.dart';
// import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
// import 'package:youtubeapp/models/video_model.dart';

// void playerPage(BuildContext context, VideoList videoObject) {
//   late YoutubePlayerController controller = YoutubePlayerController(
//     initialVideoId: "",
//   );

//   controller = YoutubePlayerController(
//     initialVideoId: videoObject.selectedVideo!.id,
//     flags: const YoutubePlayerFlags(
//       autoPlay: true,
//       mute: false,
//     ),
//   );

//   void videoOnChange(YoutubeVideo chnagedVideo) {
//     videoObject.selectedVideo = chnagedVideo;
//     controller.load(videoObject.selectedVideo!.id);
//   }

//   showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       enableDrag: true,
//       builder: (context) {
//         return Container(
//             height: MediaQuery.of(context).size.height - 61,
//             color: Colors.white,
//             child: Scaffold(
//               body: Column(
//                 children: [
//                   YoutubePlayer(
//                     controller: controller,
//                     onReady: () => {
//                       print("onReady"),
//                     },
//                   ),
//                   VideoListView(
//                     videoListInfo: videoObject,
//                     onChange: videoOnChange,
//                   ),
//                 ],
//               ),
//               floatingActionButton: Column(
//                 verticalDirection: VerticalDirection.up,
//                 children: [
//                   Container(
//                     width: 35,
//                     height: 35,
//                     child: FloatingActionButton(
//                       backgroundColor: const Color.fromARGB(255, 59, 59, 59),
//                       child: const Icon(Icons.arrow_drop_down),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     width: 35,
//                     height: 35,
//                     child: FloatingActionButton(
//                       backgroundColor: const Color.fromARGB(255, 59, 59, 59),
//                       child: const Icon(Icons.file_download),
//                       onPressed: () {
//                         downloadModal(context, videoObject.selectedVideo);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//       });
// }

// void downloadModal(BuildContext context, selectedVideo) {
//   showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           height: 300,
//           child: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.vertical(
//              top: Radius.circular(10.0),
//               ),
//               color: Color.fromARGB(255, 248, 248, 248),
//             ),
//             child: DownloadView(selectedVideo: selectedVideo),
//           ),
//         );
//       });
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/playerPage/PlayerSubView/download_view.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
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
