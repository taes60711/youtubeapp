// import 'package:flutter/material.dart';
// import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
// import 'package:youtubeapp/models/video_model.dart';
// import 'package:youtubeapp/components/playerPage/playerPage.dart';
// import 'package:youtubeapp/service/yt_service.dart';

// class VideoListView extends StatefulWidget {
//   VideoListView({
//     super.key,
//     required this.videoListInfo,
//     this.onChange,
//   });
//   VideoList videoListInfo;
//   Function? onChange;
//   @override
//   State<VideoListView> createState() => _VideoListViewState();
// }

// class _VideoListViewState extends State<VideoListView> {
//   final YTService _ytService = YTService.instance;
//   Widget listItem(
//       BuildContext context, YoutubeVideo videoOrChannelInfo, VideoList videoListInfo) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 2),
//       child: videoOrChannelInfo.kind == 'video' || videoOrChannelInfo.kind == 'channelVideo'
//           ? ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0)),
//                 padding: const EdgeInsets.all(0),
//                 backgroundColor: const Color.fromARGB(255, 33, 32, 32),
//                 elevation: 0,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 80,
//                     width: 130,
//                     child: Image(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(videoOrChannelInfo.thumbnailUrl),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             videoOrChannelInfo.title,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(videoOrChannelInfo.channelTitle)
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               onPressed: () {
//                 if (videoListInfo.routerPage == '/playerPage' ||
//                     videoListInfo.routerPage == '/channel') {
//                   widget.onChange!(videoOrChannelInfo);
//                 } else {
//                   Map<String, dynamic> videoObject = {
//                     'videoItems': videoListInfo.videoItems,
//                     'searchKey': videoListInfo.searchKey,
//                     'selectedVideo': videoOrChannelInfo,
//                     'routerPage': '/playerPage',
//                   };
//                   VideoList playerPageInfo = VideoList.fromMap(videoObject);
//                   playerPage(context, playerPageInfo);
//                 }
//               },
//             )
//           : SizedBox(
//               height: 80,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0)),
//                 padding: const EdgeInsets.all(0),
//                 backgroundColor: const Color.fromARGB(255, 61, 61, 61),
//                 elevation: 0,
//               ),
//                 onPressed: () async {
//                   List<YoutubeVideo> videoItems = await _ytService
//                       .searchVideosFromChannel(channelId: videoOrChannelInfo.id);
//                   Navigator.pushNamed(context, '/channel', arguments: {
//                     'videoItems': videoItems,
//                     'searchKey': videoOrChannelInfo.id
//                   });
//                 },
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 80,
//                       width: 130,
//                       child: Center(
//                           child: ClipRRect(
//                         borderRadius: BorderRadius.circular(40),
//                         child: Image(
//                           fit: BoxFit.cover,
//                           image: NetworkImage(videoOrChannelInfo.thumbnailUrl),
//                         ),
//                       )),
//                     ),
//                     Text(videoOrChannelInfo.channelTitle)
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScrollController _scrollController = ScrollController();

//     VideoList? videoListInfo = widget.videoListInfo;
//     return Expanded(
//       child: NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollNotification) {
//           if (scrollNotification is ScrollEndNotification) {
//             final before = scrollNotification.metrics.extentBefore;
//             final max = scrollNotification.metrics.maxScrollExtent;
//             if (before == max) {
//               if (videoListInfo.routerPage == '/channel') {
//                 _ytService
//                     .searchVideosFromChannel(channelId: videoListInfo.searchKey)
//                     .then(
//                       (value) => setState(() {
//                         videoListInfo.videoItems.addAll(value);
//                       }),
//                     );
//               } else {
//                 _ytService
//                     .searchVideosFromKeyWord(keyword: videoListInfo.searchKey)
//                     .then(
//                       (value) => setState(() {
//                         videoListInfo.videoItems.addAll(value);
//                       }),
//                     );
//               }
//             }
//           }
//           return false;
//         },
//         child: ListView.builder(
//             controller: _scrollController,
//             itemCount: videoListInfo.videoItems.length,
//             itemBuilder: (context, index) {
//               return listItem(
//                   context, videoListInfo.videoItems[index], videoListInfo);
//             }),
//       ),
//     );
//   }
// }

// DraggableScrollableSheet(
//           minChildSize: 0.1, // 最小の高さは画面の10%
//           initialChildSize: 1, // 初めて描画されるときの高さは画面の30%
//           maxChildSize: 1, // 最大の高さは画面の70%
//           controller: _scrollController,
//           builder: (BuildContext context, ScrollController scrollController) {
//             return Column(
//               children: [
//                 ElevatedButton(
//                   child: Text('Move to top'),
//                   onPressed: () {
//                     _scrollController.animateTo(1,
//                         duration: Duration(seconds: 1),
//                         curve: Curves.easeInOut);
//                   },
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                       controller: scrollController,
//                       itemCount: videoListInfo.videoItems.length,
//                       itemBuilder: (context, index) {
//                         return listItem(context,
//                             videoListInfo.videoItems[index], videoListInfo);
//                       }),
//                 ),
//               ],
//             );
//           },
//         ),

//  return Expanded(
//       child: NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollNotification) {
//           if (scrollNotification is ScrollEndNotification) {
//             final before = scrollNotification.metrics.extentBefore;
//             final max = scrollNotification.metrics.maxScrollExtent;
//             if (before == max) {
//               _ytService
//                   .searchVideosFromKeyWord(keyword: videoListInfo.searchKey)
//                   .then(
//                     (value) => setState(() {
//                       videoListInfo.videoItems.addAll(value);
//                     }),
//                   );
//             }
//           }
//           return false;
//         },
//         child: ListView.builder(
//             controller: _scrollController,
//             itemCount: videoListInfo.videoItems.length,
//             itemBuilder: (context, index) {
//               return listItem(
//                   context, videoListInfo.videoItems[index], videoListInfo);
//             }),
//       ),
//     );

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/states/playerState.dart';

class VideosListView extends StatelessWidget {
  VideosListView({super.key, required this.videoListInfo});

  VideoList videoListInfo;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
       
        BlocBuilder<VideoListCubit, VideoListState>(
          builder: ((context, state) {
            if (state is LoadingState) {
              return const LoadingWidget();
            } else {
              return Container();
            }
          }),
        )
      ],
    );
  }
}
