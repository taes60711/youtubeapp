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

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';

class playerPage extends StatelessWidget {
  const playerPage({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    VideoList selectedVideoInfo = args['selectedVideoInfo'];
    late YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: selectedVideoInfo.selectedVideo!.id as String,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Container(
      color: const Color.fromARGB(255, 27, 27, 27),
      child: Column(
        children: [
          YoutubePlayer(
            controller: controller,
            onReady: () => {
              print("onReady"),
            },
          ),
        ],
      ),
    );
  }
}
