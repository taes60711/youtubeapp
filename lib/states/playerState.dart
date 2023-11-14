import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

abstract class VideoPlayerState {
  dynamic videoItems;
  VideoPlayerState({this.videoItems});
}

class PlayerInitialState extends VideoPlayerState {
  PlayerInitialState({required List<YoutubeVideo> videoItems})
      : super(videoItems: videoItems);
}

class LoadingState extends VideoPlayerState {}

class SearchSuccesState extends VideoPlayerState {
    SearchSuccesState({required List<YoutubeVideo> videoItems})
      : super(videoItems: videoItems);
}

class SearchErrorState extends VideoPlayerState {
  final String message;
  SearchErrorState({required this.message});
}

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(PlayerInitialState(videoItems: []));
  final YTService _ytService = YTService.instance;

  Future<void> searchVideo(String keyword, String mode) async {
    emit(LoadingState());
    try {
      List<YoutubeVideo> searchResult = await _ytService
          .searchVideosFromKeyWord(keyword: keyword, mode: mode);

      emit(SearchSuccesState(videoItems: searchResult));

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
