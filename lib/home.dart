import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/video_list_state.dart';
import 'package:youtubeapp/utilities/screen_size.dart';
import 'package:youtubeapp/utilities/style_config.dart';

enum SearchType {
  url,
  normal;
}

class NoVideosView extends StatelessWidget {
  final double bgHeight;
  const NoVideosView(this.bgHeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
}

class Home extends StatelessWidget {
  Home({super.key});

  final double searchBarHeight = 35;
  final double searchBarPaddingBottom = 14;
  final double topBarHeight = 40;
  late final double bgHeight = ScreenSize().height -
      topBarHeight -
      searchBarHeight -
      searchBarPaddingBottom;

  Widget searchBar(BuildContext context) {
    //キーワードで動画リストを検索の処理する
    Future<void> doSearch(searchKeyWord) async {
      log(searchKeyWord);
      if (searchKeyWord.isNotEmpty) {
        SearchType keyWordMode;
        if (searchKeyWord.contains('https://')) {
          keyWordMode = SearchType.url;
        } else {
          keyWordMode = SearchType.normal;
        }
        VideoListCubit cubit = context.read<VideoListCubit>();
        await cubit.searchVideo(searchKeyWord, keyWordMode);
      }
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            height: searchBarHeight,
            margin: const EdgeInsets.only(left: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 162, 162, 162),
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextField(
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: searchBarPaddingBottom),
                hintText: '搜尋',
                hintStyle: TextStyle(color: normalTextColor),
                border: InputBorder.none,
              ),
              style: TextStyle(color: normalTextColor),
              onSubmitted: (value) async {
                await doSearch(context.read<VideoListCubit>().searchKeyWord);
              },
              onChanged: ((value) {
                context.read<VideoListCubit>().searchKeyWordChange(value);
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
              await doSearch(context.read<VideoListCubit>().searchKeyWord);
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: normalBgColor,
      body: Column(
        children: [
          SizedBox(height: topBarHeight),
          searchBar(context),
          Expanded(
            child: BlocBuilder<VideoListCubit, VideoListState>(
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
                  List<YoutubeItem> ytItems =
                      context.watch<VideoListCubit>().state.videoItems;
                  return ytItems.isNotEmpty
                      ? VideosListView(ytItems: ytItems,)
                      : NoVideosView(bgHeight);
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}
