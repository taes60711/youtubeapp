// // ignore_for_file: slash_for_doc_comments, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:youtubeapp/components/loading.dart';
// import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
// import 'package:youtubeapp/components/playerPage/playerPage.dart';
// import 'package:youtubeapp/models/video_model.dart';
// import 'package:youtubeapp/states/playerState.dart';
// import 'package:youtubeapp/components/playerPage/PlayerSubView/listView.dart';

// class Home extends StatelessWidget {
//   String _searchKey = "";

// /**
//  * キーワードで動画リストを検索の処理する
//  */
//   Future<void> searchVideoItems(BuildContext context, String mode) async {
//     switch (mode) {
//       case 'URL':
//         String tmpId = context.read<VideoPlayerCubit>().getVideoId(_searchKey);
//         print("Result ID : ${tmpId}");
//         String videoTitle =
//             await context.read<VideoPlayerCubit>().searchVideoDetail(tmpId);
//         await context.read<VideoPlayerCubit>().searchVideo(videoTitle, 'URL');
//         _searchKey = videoTitle;
//         List<YoutubeItem> searchedVideoItems =
//             context.read<VideoPlayerCubit>().state.videoItems;
//         int index =
//             searchedVideoItems.indexWhere((element) => element.id == tmpId);
//         var tmpVideo = searchedVideoItems[0];
//         searchedVideoItems[0] = searchedVideoItems[index];
//         searchedVideoItems[index] = tmpVideo;

//         Map<String, dynamic> videoObject = {
//           'videoItems': searchedVideoItems,
//           'searchKey': videoTitle,
//           'selectedVideo': searchedVideoItems[0],
//           'routerPage': '/playerPage',
//         };
//         VideoList playerPageInfo = VideoList.fromMap(videoObject);
//         playerPage(context, playerPageInfo);
//         break;
//       case 'NORMAL':
//         await context.read<VideoPlayerCubit>().searchVideo(_searchKey, 'URL');
//         break;
//     }
//   }

//   Widget searchBar(context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter a search',
//                 border: InputBorder.none,
//               ),
//               onChanged: ((value) {
//                 _searchKey = value;
//               })),
//         ),
//         IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () async {
//               if (_searchKey.isNotEmpty) {
//                 String mode = '';
//                 if (_searchKey.contains('https://')) {
//                   mode = 'URL';
//                 } else {
//                   mode = 'NORMAL';
//                 }
//                 await searchVideoItems(context, mode);
//               }
//             }),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 61,
//           color: Colors.black,
//         ),
//         searchBar(context),
//         BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
//           builder: ((context, state) {
//             if (state is LoadingState) {
//               return const LoadingWidget();
//             } else {
//               Map<String, dynamic> videoListObject = {
//                 'videoItems': state.videoItems,
//                 'searchKey': _searchKey,
//                 'routerPage': 'home',
//               };
//               VideoList videoListInfo = VideoList.fromMap(videoListObject);
//               return state.videoItems.isNotEmpty
//                   ? VideoListView(videoListInfo: videoListInfo)
//                   : const Expanded(
//                       child: Center(
//                         child: Icon(
//                           Icons.subtitles_off,
//                           size: 100,
//                         ),
//                       ),
//                     );
//             }
//           }),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/listView.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/playerState.dart';

class Home extends StatelessWidget {
  Home({super.key});
  String searchKey = "";

  //キーワードで動画リストを検索の処理する
  Future<void> searchVideoItems(BuildContext context, String mode) async {
    var cubit = context.read<VideoListCubit>();
    switch (mode) {
      case 'URL':
        String tmpId = cubit.getVideoId(searchKey);
        print("Result ID : ${tmpId}");
        String videoTitle = await cubit.searchVideoDetail(tmpId);
        await cubit.searchVideo(videoTitle, 'URL');
        List<YoutubeItem> searchedVideoItems = cubit.state.videoItems;

        int index = searchedVideoItems.indexWhere((video) => video.id == tmpId);
        var tmpVideo = searchedVideoItems[0];
        searchedVideoItems[0] = searchedVideoItems[index];
        searchedVideoItems[index] = tmpVideo;

        VideoList(
            videoItems: searchedVideoItems,
            searchKey: videoTitle,
            selectedVideo: searchedVideoItems[0],
            routerPage: '/playerPage');
        break;
      case 'NORMAL':
        await cubit.searchVideo(searchKey, 'URL');
        break;
    }
  }

  //検索バー
  Widget searchBar(context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter a search',
                border: InputBorder.none,
              ),
              onChanged: ((value) {
                searchKey = value;
              })),
        ),
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              if (searchKey.isNotEmpty) {
                String keyWordMode = '';
                if (searchKey.contains('https://')) {
                  keyWordMode = 'URL';
                } else {
                  keyWordMode = 'NORMAL';
                }
                await searchVideoItems(context, keyWordMode);
              }
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 61,
          color: Colors.black,
        ),
        searchBar(context),
        BlocBuilder<VideoListCubit, VideoListState>(
          builder: ((context, state) {
            if (state is LoadingState) {
              return const LoadingWidget();
            } else {
              VideoList videoListInfo = VideoList(
                  videoItems: state.videoItems,
                  searchKey: searchKey,
                  routerPage: '/home');
              return state.videoItems.isNotEmpty
                  ? VideosListView(videoListInfo: videoListInfo)
                  : const Expanded(
                      child: Center(
                        child: Icon(
                          Icons.subtitles_off,
                          size: 100,
                        ),
                      ),
                    );
            }
          }),
        ),
      ],
    );
  }
}
