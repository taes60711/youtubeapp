import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/components/playerPage/video_list_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/videoListState.dart';
import 'package:youtubeapp/utilities/screen_size.dart';
import 'package:youtubeapp/utilities/style_config.dart';

class Home extends StatelessWidget {
  Home({super.key});
  String searchKey = "";
  final double searchBarHeight = 35;
  final double searchBarPaddingBottom = 14;
  final double topBarHeight = 40;
  late double bgHeight = ScreenSize().height - topBarHeight - searchBarHeight - searchBarPaddingBottom  ;
  //キーワードで動画リストを検索の処理する
  Future<void> searchVideoItems(BuildContext context, String mode) async {
    VideoListCubit cubit = context.read<VideoListCubit>();
    switch (mode) {
      case 'URL':
        String tmpId = cubit.getVideoId(searchKey);
        log("Result ID : $tmpId");
        String videoTitle = await cubit.searchVideoDetail(tmpId);
        await cubit.searchVideo(videoTitle, 'URL');

        List<YoutubeItem> searchedVideoItems = cubit.state.videoItems;
        int index = searchedVideoItems.indexWhere((video) => video.id == tmpId);
        void searchResultOrder(
            int index, List<YoutubeItem> searchedVideoItems) {
          YoutubeItem tmpVideo = searchedVideoItems[0];
          searchedVideoItems[0] = searchedVideoItems[index];
          searchedVideoItems[index] = tmpVideo;
        }
        searchResultOrder(index, searchedVideoItems);

        VideoList(
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
    Future<void> doSearch(searchKey) async {
      log(searchKey);
      if (searchKey.isNotEmpty) {
        String keyWordMode = '';
        if (searchKey.contains('https://')) {
          keyWordMode = 'URL';
        } else {
          keyWordMode = 'NORMAL';
        }
        await searchVideoItems(context, keyWordMode);
      }
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: searchBarHeight,
            margin:const EdgeInsets.only(left: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 162, 162, 162),
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextField(
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 10, bottom: searchBarPaddingBottom),
                hintText: '搜尋',
                hintStyle: TextStyle(
                  color: normalTextColor,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: normalTextColor,
              ),
              onSubmitted: (value) async {
                await doSearch(searchKey);
              },
              onChanged: ((value) {
                searchKey = value;
              }),
            ),
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.search,
              color: normalTextColor,
            ),
            onPressed: () async {
              await doSearch(searchKey);
            }),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    log('HomePage route: ${ModalRoute.of(context)!.settings.name}');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: normalBgColor,
        child: Column(
          children: [
            Container(
              height: topBarHeight,
              color: normalBgColor,
            ),
            searchBar(context),
            BlocBuilder<VideoListCubit, VideoListState>(
              builder: ((context, state) {
                if (state is LoadingState) {
                  return SizedBox(
                    height: bgHeight,
                    child: const Center(
                      child: LoadingWidget(
                        circularSize: 70,
                        strokeWidth: 10,
                      ),
                    ),
                  );
                } else {
                  VideoList videoListInfo =
                      VideoList(searchKey: searchKey, routerPage: '/home');
                  return state.videoItems.isNotEmpty
                      ? Expanded(
                          child: VideosListView(videoListInfo: videoListInfo),
                        )
                      : SizedBox(
                          height: bgHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.subtitles_off,
                                size: 100,
                                color: normalTextColor,
                              ),
                              Text(
                                '沒有影片資訊...',
                                style: TextStyle(color: normalTextColor),
                              ),
                            ],
                          ),
                        );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
