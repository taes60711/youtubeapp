import 'package:flutter/material.dart';
import 'package:youtubeapp/models/video_model.dart';

class VideoListView extends StatefulWidget {
  VideoListView({super.key, required this.videoItems,required this.inPage, this.onChange});
  List<YoutubeVideo> videoItems = [];
  String inPage='';
  Function? onChange;
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
               if(widget.inPage == '/playerPage'){
                 print("inpage");
                 widget.onChange!(videoInfo.id);
               }else{
                Navigator.of(context).pushNamed("/playerPage",
                    arguments: {'ID': videoInfo.id, 'VideoItems': widget.videoItems});
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
    print("VideoListView：${widget.inPage}");
    
    return Expanded(
      child: ListView.builder(
          itemCount: widget.videoItems.length,
          itemBuilder: (context, index) {
            return listItem(widget.videoItems[index]);
          }),
    );
  }
}
