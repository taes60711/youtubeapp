import 'package:flutter/material.dart';
import 'package:youtubeapp/models/video_model.dart';

class VideoListView extends StatefulWidget {
  VideoListView({super.key, required this.videoInfo});
  List<YoutubeVideo> videoInfo = [];
  @override
  State<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  Widget listItem(YoutubeVideo videoInfo) {
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
                Navigator.of(context)
                    .pushNamed("/playerPage", arguments: {'ID': videoInfo.id});
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
    print("VideoListView");
    return Expanded(
      child: ListView.builder(
          itemCount: widget.videoInfo.length,
          itemBuilder: (context, index) {
            return listItem(widget.videoInfo[index]);
          }),
    );
  }
}
