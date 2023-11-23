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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/videoListState.dart';

class VideosListView extends StatelessWidget {
  VideosListView({
    super.key,
    required this.videoListInfo,
    this.onChange,
  });

  final VideoList videoListInfo;
  Function? onChange;

  @override
  Widget build(BuildContext context) {
    DraggableScrollableController draggableScrollableController =
        DraggableScrollableController();
    ScrollController scrollController = ScrollController();
    var cubit = context.read<VideoListCubit>();
    List<YoutubeItem> videoItems = cubit.state.videoItems;

    Widget videolistView(ScrollController? scrollController) {
      return Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  final before = scrollNotification.metrics.extentBefore;
                  final max = scrollNotification.metrics.maxScrollExtent;
                  if (before == max && cubit.state is! AddLoadingState) {
                    cubit.addListVideo(videoItems, videoListInfo.searchKey);
                  }
                }
                return false;
              },
              child:  ListView.builder(
                    controller: scrollController,
                    itemCount: videoItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 1, left: 10, right: 10),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 143, 143, 143),
                                  width: .5),
                            ),
                          ),
                          child: videoItems[index].kind == 'video'
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    backgroundColor:
                                        const Color.fromARGB(0, 154, 103, 103),
                                    elevation: 0,
                                  ),
                                  onPressed: (() {
                                    var selectedVideoInfo = VideoList(
                                        searchKey: videoListInfo.searchKey,
                                        selectedVideo: videoItems[index],
                                        routerPage: '/playerPage');
                                    if (videoListInfo.routerPage == '/home') {
                                      Navigator.of(context)
                                          .pushNamed('/playerPage', arguments: {
                                        'selectedVideoInfo': selectedVideoInfo
                                      });
                                    } else {
                                      onChange!(videoItems[index]);
                                    }
                                  }),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 130,
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              videoItems[index].thumbnailUrl),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Text(
                                                  videoItems[index].title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                videoItems[index].channelTitle,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 80,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      backgroundColor: const Color.fromARGB(
                                          255, 68, 86, 147),
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      Navigator.pushNamed(context, '/channel',
                                          arguments: {
                                            'videoItems': videoItems,
                                            'searchKey': videoItems[index].id
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 80,
                                          width: 130,
                                          child: Center(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  videoItems[index]
                                                      .thumbnailUrl),
                                            ),
                                          )),
                                        ),
                                        Text(videoItems[index].channelTitle)
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }),
              ),
          ),
          BlocBuilder<VideoListCubit, VideoListState>(
            builder: ((context, state) {
              if (state is AddLoadingState) {
                return const LoadingWidget();
              } else {
                return Container();
              }
            }),
          )
        ],
      );
    }

    print('object${videoListInfo.routerPage}');
    return videoListInfo.routerPage == '/playerPage'
        ? DraggableScrollableSheet(
            minChildSize: 0.8,
            initialChildSize: 1,
            maxChildSize: 1,
            controller: draggableScrollableController,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: const Color.fromARGB(255, 27, 27, 27),
                child: Column(
                  children: [
                    const Icon(
                      Icons.remove,
                      size: 35,
                      color: Color.fromARGB(255, 143, 143, 143),
                    ),
                    Expanded(child: videolistView(scrollController))
                  ],
                ),
              );
            })
        : videolistView(null);
  }
}
