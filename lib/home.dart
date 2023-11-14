// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/states/playerState.dart';
import 'package:youtubeapp/components/youtubePlayer/listView.dart';

class Home extends StatelessWidget {
  String _searchKey = "";

/**
 * キーワードで動画リストを検索の処理する
 */
  Future<void> searchVideoItems(BuildContext context, String mode) async {
    switch (mode) {
      case 'URL':
        String tmpId = context.read<VideoPlayerCubit>().getVideoId(_searchKey);
        print("Result ID : ${tmpId}");
        String videoTitle =
            await context.read<VideoPlayerCubit>().searchVideoDetail(tmpId);
        await context.read<VideoPlayerCubit>().searchVideo(videoTitle, 'URL');
        List<YoutubeVideo> searchedVideoItems =
            context.read<VideoPlayerCubit>().state.videoItems;
        Navigator.of(context).pushNamed("/playerPage", arguments: {
          'videoInfo': searchedVideoItems[0],
          'VideoItems': searchedVideoItems,
          'searchKey': tmpId
        });
        break;
      case 'NORMAL':
        await context.read<VideoPlayerCubit>().searchVideo(_searchKey, 'URL');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 61,
          color: Colors.black,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter a search',
                    border: InputBorder.none,
                  ),
                  onChanged: ((value) {
                    _searchKey = value;
                  })),
            ),
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  String mode = '';
                  if (_searchKey.isNotEmpty) {
                    if (_searchKey.contains('https://')) {
                      mode = 'URL';
                    } else {
                      mode = 'NORMAL';
                    }
                    await searchVideoItems(context, mode);
                  }
                }),
          ],
        ),
        BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
          builder: ((context, state) {
            if (state is LoadingState) {
              return const LoadingWidget();
            } else {
              return state.videoItems.isNotEmpty
                  ? VideoListView(
                      videoItems: state.videoItems,
                      inPage: ModalRoute.of(context)?.settings.name as String,
                      searchKey: _searchKey)
                  : const Expanded(
                      child: Center(
                        child: Icon(
                          Icons.subtitles_off,
                          size: 100,
                        ),
                      ),
                    );
            }
          }),
        ),
      ],
    );
  }
}
