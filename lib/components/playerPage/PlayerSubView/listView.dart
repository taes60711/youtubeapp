import 'package:flutter/material.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/components/playerPage/playerPage.dart';
import 'package:youtubeapp/service/yt_service.dart';

class VideoListView extends StatefulWidget {
  VideoListView({
    super.key,
    required this.videoListInfo,
    this.onChange,
  });
  VideoList videoListInfo;
  Function? onChange;
  @override
  State<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  Widget listItem(
      BuildContext context, YoutubeVideo videoInfo, VideoList videoListInfo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: videoInfo.kind == 'video'
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
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
                      image: NetworkImage(videoInfo.thumbnailUrl),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videoInfo.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(videoInfo.channelTitle)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                if (videoListInfo.routerPage == '/playerPage') {
                  widget.onChange!(videoInfo);
                } else {
                  Map<String, dynamic> videoObject = {
                    'videoItems': videoListInfo.videoItems,
                    'searchKey': videoListInfo.searchKey,
                    'selectedVideo': videoInfo,
                    'routerPage': '/playerPage',
                  };
                  VideoList playerPageInfo = VideoList.fromMap(videoObject);
                  playerPage(context, playerPageInfo);
                }
              },
            )
          : SizedBox(
              height: 80,
              child: Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 130,
                    child: Center(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(videoInfo.thumbnailUrl),
                      ),
                    )),
                  ),
                  Text(videoInfo.channelTitle)
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    final YTService _ytService = YTService.instance;
    VideoList? videoListInfo = widget.videoListInfo;
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            final before = scrollNotification.metrics.extentBefore;
            final max = scrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _ytService
                  .searchVideosFromKeyWord(keyword: videoListInfo.searchKey)
                  .then(
                    (value) => setState(() {
                      videoListInfo.videoItems.addAll(value);
                    }),
                  );
            }
          }
          return false;
        },
        child: ListView.builder(
            controller: _scrollController,
            itemCount: videoListInfo.videoItems.length,
            itemBuilder: (context, index) {
              return listItem(
                  context, videoListInfo.videoItems[index], videoListInfo);
            }),
      ),
    );
  }
}
