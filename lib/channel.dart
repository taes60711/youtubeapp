// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:youtubeapp/components/playerPage/video_list_model.dart';
// import 'package:youtubeapp/models/video_model.dart';
// import 'package:youtubeapp/service/yt_service.dart';

// class Channel extends StatefulWidget {
//   const Channel({super.key});

//   @override
//   State<Channel> createState() => _ChannelState();
// }

// class _ChannelState extends State<Channel> {
//   @override
//   Widget build(BuildContext context) {
//     log('Channel ${ModalRoute.of(context)!.settings.name}');
//     dynamic args = ModalRoute.of(context)!.settings.arguments;
//     List<ChannelItem> videoItems = args['videoItems'];
//     final YTService ytService = YTService.instance;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 48, 48, 48),
//       ),
//       body: Container(
//         color: const Color.fromARGB(255, 27, 27, 27),
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (ScrollNotification scrollNotification) {
//             if (scrollNotification is ScrollEndNotification) {
//               final before = scrollNotification.metrics.extentBefore;
//               final max = scrollNotification.metrics.maxScrollExtent;
//               if (before == max) {
//                 ytService
//                     .searchVideosFromChannel(channelId: args['searchKey'])
//                     .then(
//                       (value) => setState(() {
//                         videoItems.addAll(value);
//                       }),
//                     );
//               }
//             }
//             return false;
//           },
//           child: ListView.builder(
//               itemCount: videoItems.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding:
//                       const EdgeInsets.only(bottom: 1, left: 10, right: 10),
//                   child: Container(
//                       padding: const EdgeInsets.only(bottom: 5),
//                       decoration: const BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                               color: Color.fromARGB(255, 143, 143, 143),
//                               width: .5),
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(0)),
//                           padding: const EdgeInsets.symmetric(horizontal: 0),
//                           backgroundColor:
//                               const Color.fromARGB(0, 154, 103, 103),
//                           elevation: 0,
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 80,
//                               width: 130,
//                               child: Image(
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage(
//                                     videoItems[index].thumbnailUrl),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       videoItems[index].title,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       videoItems[index].channelTitle,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                         onPressed: () {
//                           YoutubeItem selectedVideo = YoutubeItem(
//                               title: videoItems[index].title,
//                               thumbnailUrl: videoItems[index].thumbnailUrl,
//                               channelTitle: videoItems[index].channelTitle,
//                               publishedAt: videoItems[index].publishedAt,
//                               id: videoItems[index].channelVideoId);

//                           VideoList selectedVideoInfo = VideoList(
//                               searchKey: args['searchKey'],
//                               selectedVideo: selectedVideo,
//                               routerPage: '/playerPage');

//                           Navigator.of(context).pushNamed('/playerPage',
//                               arguments: {
//                                 'selectedVideoInfo': selectedVideoInfo
//                               });
//                         },
//                       )),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/states/channel_list_state.dart';
import 'package:youtubeapp/utilities/style_config.dart';

class Channel extends StatelessWidget {
  const Channel({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    String selectedChannelId = args['selectedChannel'];

    return BlocBuilder<ChannelListCubit, ChannelListState>(
      builder: ((context, state) {
        if (state.videoItems.isNotEmpty) {
          return Scaffold(
              backgroundColor: normalBgColor,
              body: ListView.builder(
                  itemCount: state.videoItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 1),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: normalTextColor as Color, width: .5),
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          backgroundColor: normalBgColor,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 130,
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    state.videoItems[index].thumbnailUrl),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        state.videoItems[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Text(
                                      state.videoItems[index].channelTitle,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, color: normalTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }));
        } else {
          context.read<ChannelListCubit>().searchVideo(selectedChannelId);
          return Scaffold(
            backgroundColor: normalBgColor,
            body: const Center(
              child: LoadingWidget(
                circularSize: 70,
                strokeWidth: 10,
              ),
            ),
          );
        }
      }),
    );
  }
}
