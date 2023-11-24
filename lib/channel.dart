import 'package:flutter/material.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

class Channel extends StatefulWidget {
  const Channel({super.key});

  @override
  State<Channel> createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    List<ChannelItem> videoItems = args['videoItems'];
    final YTService _ytService = YTService.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      ),
      body: Container(
        color: const Color.fromARGB(255, 27, 27, 27),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              final before = scrollNotification.metrics.extentBefore;
              final max = scrollNotification.metrics.maxScrollExtent;
              if (before == max) {
                _ytService
                    .searchVideosFromChannel(channelId: args['searchKey'])
                    .then(
                      (value) => setState(() {
                        videoItems.addAll(value);
                      }),
                    );
              }
            }
            return false;
          },
          child: ListView.builder(
              itemCount: videoItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 1, left: 10, right: 10),
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 143, 143, 143),
                              width: .5),
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          backgroundColor:
                              const Color.fromARGB(0, 154, 103, 103),
                          elevation: 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videoItems[index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(videoItems[index].channelTitle),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          var selectedVideo = YoutubeItem(
                              title: videoItems[index].title,
                              thumbnailUrl: videoItems[index].thumbnailUrl,
                              channelTitle: videoItems[index].channelTitle,
                              publishedAt: videoItems[index].publishedAt,
                              id: videoItems[index].channelVideoId);
                          var selectedVideoInfo = VideoList(
                              searchKey: args['searchKey'],
                              selectedVideo: selectedVideo,
                              routerPage: '/playerPage');

                          Navigator.of(context).pushNamed('/playerPage',
                              arguments: {
                                'selectedVideoInfo': selectedVideoInfo
                              });
                        },
                      )),
                );
              }),
        ),
      ),
    );
  }
}
