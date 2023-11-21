import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/listView.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/videoListState.dart';

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
          child: Container(
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 162, 162, 162),
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, bottom: 14),
                hintText: 'Enter a search',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 143, 143, 143),
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Color.fromARGB(255, 143, 143, 143),
              ),
              onChanged: ((value) {
                searchKey = value;
              }),
            ),
          ),
        ),
        IconButton(
            icon: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 143, 143, 143),
            ),
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
    return Container(
      color: const Color.fromARGB(255, 27, 27, 27),
      child: Column(
      children: [
        Container(
          height: 40,
          color: const Color.fromARGB(255, 27, 27, 27),
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
                          color: Color.fromARGB(255, 143, 143, 143),
                        ),
                      ),
                    );
            }
          }),
        ),
      ],
    )
    );
  }
}



