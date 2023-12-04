import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/home.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

abstract class VideoListState {
  dynamic videoItems = [];
  VideoListState({this.videoItems});
}

class ListInitialState extends VideoListState {
  ListInitialState({required List<YoutubeItem> videoItems})
      : super(videoItems: videoItems);
}

class LoadingState extends VideoListState {}

class AddLoadingState extends VideoListState {
  AddLoadingState({required List<YoutubeItem> videoItems})
      : super(videoItems: videoItems);
}

class SearchSuccesState extends VideoListState {
  SearchSuccesState(
      {required List<YoutubeItem> videoItems, required String searchKeyWord})
      : super(videoItems: videoItems);
}

class SearchErrorState extends VideoListState {
  final String message;
  SearchErrorState({required this.message});
}

class VideoListCubit extends Cubit<VideoListState> {
  String? searchKeyWord = '';
  YoutubeItem? selectedItem ;
  VideoListCubit({this.searchKeyWord,this.selectedItem})
      : super(ListInitialState(videoItems: []));
  final YTService _ytService = YTService.instance;

  void searchKeyWordChange(String value) {
    searchKeyWord = value;
  }

  Future<void> searchVideo(String searchKeyWord, SearchType type,
      {List<YoutubeItem>? videoItems}) async {
    doSearchORAddVideos(void emits,
        {List<YoutubeItem>? videoItems, String? videoId}) async {
      emits;
      try {
        List<YoutubeItem> searchResult =
            await _ytService.searchVideosFromKeyWord(keyword: searchKeyWord);
        List<YoutubeItem> returnVideoItems = (videoItems ?? [])
          ..addAll(searchResult);
        if (videoId != null) {
          int index =
              returnVideoItems.indexWhere((video) => video.id == videoId);
          YoutubeItem tmpVideo = returnVideoItems[0];
          returnVideoItems[0] = returnVideoItems[index];
          returnVideoItems[index] = tmpVideo;
        }
        emit(SearchSuccesState(
            videoItems: returnVideoItems, searchKeyWord: searchKeyWord));
      } catch (error) {
        emit(SearchErrorState(message: error.toString()));
        rethrow;
      }
    }

    if (videoItems != null) {
      //既に検索されたデータ含めて，ビデオリストに追加する
      doSearchORAddVideos(emit(AddLoadingState(videoItems: videoItems)),
          videoItems: videoItems);
    } else {
      String? videoId;
      if (type == SearchType.url) {
        //URLで検索したらビデオの細かい資料取得する，例：タイトル，タグ
        videoId = _ytService.getVideoID(searchKeyWord);
        searchKeyWord = await _ytService.searchVideoDetail(videoId: videoId);
      }
      //ホームで検索際に，既に検索されたデータ要らなくてデータ取得する
      doSearchORAddVideos(emit(LoadingState()), videoId: videoId);
    }
  }
}
