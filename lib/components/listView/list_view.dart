// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:youtubeapp/components/loading.dart';
// import 'package:youtubeapp/components/playerPage/video_list_model.dart';
// import 'package:youtubeapp/models/video_model.dart';
// import 'package:youtubeapp/service/yt_service.dart';
// import 'package:youtubeapp/states/videoListState.dart';
// import 'package:youtubeapp/utilities/style_config.dart';

// class VideosListView extends StatelessWidget {
//   VideosListView({
//     super.key,
//     required this.videoListInfo,
//     this.onChange,
//   });

//   final VideoList videoListInfo;
//   Function? onChange;

//   @override
//   Widget build(BuildContext context) {
//     final String inRoutePath = ModalRoute.of(context)!.settings.name ?? '/';
//     log('list_view route: $inRoutePath');
//     DraggableScrollableController draggableScrollableController =
//         DraggableScrollableController();
//     var cubit = context.read<VideoListCubit>();
//     final YTService _ytService = YTService.instance;
//     List<YoutubeItem> videoItems = cubit.state.videoItems;

//     Widget videolistView(ScrollController? scrollController) {
//       return Column(
//         children: [
//           Expanded(
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (ScrollNotification scrollNotification) {
//                 if (scrollNotification is ScrollEndNotification) {
//                   final before = scrollNotification.metrics.extentBefore;
//                   final max = scrollNotification.metrics.maxScrollExtent;
//                   if (before == max && cubit.state is! AddLoadingState) {
//                     cubit.addListVideo(videoItems, videoListInfo.searchKey);
//                   }
//                 }
//                 return false;
//               },
//               child: ListView.builder(
//                   controller: scrollController,
//                   itemCount: videoItems.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding:
//                           const EdgeInsets.only(bottom: 1, left: 10, right: 10),
//                       child: Container(
//                         padding: const EdgeInsets.only(bottom: 5),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                                 color: normalTextColor as Color, width: .5),
//                           ),
//                         ),
//                         child: videoItems[index].kind == 'video'
//                             ? ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(0)),
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 0),
//                                   backgroundColor: normalBgColor,
//                                   elevation: 0,
//                                 ),
//                                 onPressed: (() {
//                                   var selectedVideoInfo = VideoList(
//                                       searchKey: videoListInfo.searchKey,
//                                       selectedVideo: videoItems[index]);
//                                   if (inRoutePath == '/') {
//                                     Navigator.of(context)
//                                         .pushNamed('/playerPage', arguments: {
//                                       'selectedVideoInfo': selectedVideoInfo
//                                     });
//                                   } else {
//                                     onChange!(videoItems[index]);
//                                   }
//                                 }),
//                                 child: Row(
//                                   children: [
//                                     SizedBox(
//                                       height: 80,
//                                       width: 130,
//                                       child: Image(
//                                         fit: BoxFit.cover,
//                                         image: NetworkImage(
//                                             videoItems[index].thumbnailUrl),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   bottom: 8),
//                                               child: Text(
//                                                 videoItems[index].title,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             Text(
//                                               videoItems[index].channelTitle,
//                                               overflow: TextOverflow.ellipsis,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : SizedBox(
//                                 height: 80,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     padding:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     backgroundColor:
//                                         const Color.fromARGB(255, 68, 86, 147),
//                                     elevation: 0,
//                                   ),
//                                   onPressed: () async {
//                                     List<ChannelItem> channelVideoItems =
//                                         await _ytService
//                                             .searchVideosFromChannel(
//                                                 channelId: videoItems[index].id
//                                                     as String);
//                                     Navigator.of(context).pushNamed('/channel',
//                                         arguments: {
//                                           'videoItems': channelVideoItems,
//                                           'searchKey': videoItems[index].id
//                                         });
//                                   },
//                                   child: Row(
//                                     children: [
//                                       SizedBox(
//                                         height: 80,
//                                         width: 110,
//                                         child: Center(
//                                             child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(40),
//                                           child: Image(
//                                             fit: BoxFit.cover,
//                                             image: NetworkImage(
//                                                 videoItems[index].thumbnailUrl),
//                                           ),
//                                         )),
//                                       ),
//                                       Text(
//                                         videoItems[index].channelTitle,
//                                         overflow: TextOverflow.ellipsis,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     );
//                   }),
//             ),
//           ),
//           BlocBuilder<VideoListCubit, VideoListState>(
//             builder: ((context, state) {
//               if (state is AddLoadingState) {
//                 return const LoadingWidget();
//               } else {
//                 return Container();
//               }
//             }),
//           )
//         ],
//       );
//     }

//     return inRoutePath == '/playerPage'
//         ? DraggableScrollableSheet(
//             minChildSize: 0.8,
//             initialChildSize: 1,
//             maxChildSize: 1,
//             controller: draggableScrollableController,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return Container(
//                 color: normalBgColor,
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.remove,
//                       size: 35,
//                       color: normalTextColor,
//                     ),
//                     Expanded(child: videolistView(scrollController))
//                   ],
//                 ),
//               );
//             })
//         : videolistView(null);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/home.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/video_list_state.dart';
import 'package:youtubeapp/utilities/style_config.dart';

class VideosListView extends StatelessWidget {
  VideosListView({super.key, this.selectedVideoChange});
  Function? selectedVideoChange;
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    final String inRoutePath = ModalRoute.of(context)!.settings.name ?? '/';
    return BlocBuilder<VideoListCubit, VideoListState>(
      builder: ((context, state) {
        List<YoutubeItem> ytItems =
            context.watch<VideoListCubit>().state.videoItems;

        Widget vidoList({ScrollController? scrollController}) {
          return Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      final before = scrollNotification.metrics.extentBefore;
                      final max = scrollNotification.metrics.maxScrollExtent;
                      if (before == max && state is! AddLoadingState) {
                        VideoListCubit cubit = context.read<VideoListCubit>();
                        String searchedWord = cubit.searchKeyWord as String;
                        cubit.searchVideo(searchedWord, SearchType.normal,
                            videoItems: ytItems);
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                      itemCount: ytItems.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return ytItems[index].kind == 'video'
                            ? VideoItem(
                                ytItems,
                                inRoutePath,
                                index,
                                selectedVideoChange: selectedVideoChange,
                              )
                            : Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                height: 80,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    backgroundColor:
                                        const Color.fromARGB(255, 68, 86, 147),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {},
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 110,
                                        child: Center(
                                            child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                ytItems[index].thumbnailUrl),
                                          ),
                                        )),
                                      ),
                                      Text(
                                        ytItems[index].channelTitle,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                              );
                      }),
                ),
              ),
              (state is AddLoadingState) ? const LoadingWidget() : Container()
            ],
          );
        }

        return inRoutePath == '/playerPage'
            ? DraggableScrollableSheet(
                minChildSize: 0.8,
                initialChildSize: 1,
                maxChildSize: 1,
                controller: draggableScrollableController,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    color: normalBgColor,
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          size: 35,
                          color: normalTextColor,
                        ),
                        Expanded(
                          child: vidoList(scrollController: scrollController),
                        )
                      ],
                    ),
                  );
                })
            : vidoList();
      }),
    );
  }
}

class VideoItem extends StatelessWidget {
  VideoItem(this.ytItems, this.inRoutePath, this.index,
      {super.key, this.selectedVideoChange});
  final List<YoutubeItem> ytItems;
  final String inRoutePath;
  final int index;
  Function? selectedVideoChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 1),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: normalTextColor as Color, width: .5),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          backgroundColor: normalBgColor,
          elevation: 0,
        ),
        onPressed: () {
          if (inRoutePath == '/') {
            Navigator.of(context).pushNamed('/playerPage', arguments: {
              'selectedVideo': ytItems[index],
              'selectedIndex': index
            });
          } else {
            selectedVideoChange!(ytItems[index]);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: 130,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(ytItems[index].thumbnailUrl),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        ytItems[index].title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      ytItems[index].channelTitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: normalTextColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
