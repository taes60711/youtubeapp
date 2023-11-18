import 'package:flutter/material.dart';
import 'package:youtubeapp/models/video_model.dart';


class Channel extends StatefulWidget {
  const Channel({super.key});

  @override
  State<Channel> createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    List<YoutubeVideo> videoItems = args['videoItems'];

    return  Scaffold(
      appBar: AppBar(),
      body: ListView.builder( 
        itemCount: videoItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  padding: const EdgeInsets.all(0),
                  backgroundColor: Color.fromARGB(255, 33, 32, 32),
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
                        image: NetworkImage(videoItems[index].thumbnailUrl),
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
                            Text(videoItems[index].channelTitle)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  
                },
                          ),
              );
            }),
    );
  }
}