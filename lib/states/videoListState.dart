import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/playerPage/VideoList_model.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

abstract class VideoListState {
  dynamic videoItems = [];
  dynamic searchKey = '';
  VideoListState({this.videoItems, this.searchKey});
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
  SearchSuccesState({required List<YoutubeItem> videoItems})
      : super(videoItems: videoItems);
}

class SearchErrorState extends VideoListState {
  final String message;
  SearchErrorState({required this.message});
}

class VideoListCubit extends Cubit<VideoListState> {
  VideoListCubit() : super(ListInitialState(videoItems: []));
  final YTService _ytService = YTService.instance;

  Future<void> searchVideo(String keyword, String mode) async {
    emit(LoadingState());
    try {
      List<YoutubeItem> searchResult = await _ytService.searchVideosFromKeyWord(
          keyword: keyword, mode: mode);
      emit(SearchSuccesState(videoItems: searchResult));
    } catch (error) {
      emit(SearchErrorState(message: error.toString()));
      rethrow;
    }
  }

  Future<void> addListVideo(List<YoutubeItem> videoItems,String keyword) async {
     emit(AddLoadingState(videoItems: videoItems));
    try {
      List<YoutubeItem> searchResult = await _ytService.searchVideosFromKeyWord(
          keyword: keyword, mode: 'keyWord');
      videoItems.addAll(searchResult);
      emit(SearchSuccesState(videoItems: videoItems));
    } catch (error) {
      emit(SearchErrorState(message: error.toString()));
      rethrow;
    }
  }

  Future<String> searchVideoDetail(String videoId) async {
    emit(LoadingState());
    try {
      var videoTitle = await _ytService.searchVideoDetail(videoId: videoId);
      return videoTitle;
    } catch (error) {
      emit(SearchErrorState(message: error.toString()));
      rethrow;
    }
  }

  String getVideoId(String _searchKey) {
    try {
      var videoId = _ytService.getVideoID(_searchKey);
      return videoId;
    } catch (error) {
      emit(SearchErrorState(message: error.toString()));
      rethrow;
    }
  }
}
