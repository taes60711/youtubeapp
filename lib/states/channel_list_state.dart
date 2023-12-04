import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

abstract class ChannelListState {
  dynamic videoItems = [];
  ChannelListState({this.videoItems});
}

class ListInitialState extends ChannelListState {
  ListInitialState({required List<YoutubeItem> videoItems})
      : super(videoItems: videoItems);
}

class LoadingState extends ChannelListState {}

class SearchSuccesState extends ChannelListState {
  SearchSuccesState(List<YoutubeItem> videoItems)
      : super(videoItems: videoItems);
}

class ChannelListCubit extends Cubit<ChannelListState> {
  ChannelListCubit() : super(ListInitialState(videoItems: []));
  final YTService _ytService = YTService.instance;

  Future<void> searchVideo(String channelId) async {
    emit(LoadingState());
    try {
      List<YoutubeItem> searchResult =
          await _ytService.searchVideosFromChannel(channelId: channelId);
      
      emit(SearchSuccesState(searchResult));
    } catch (e) {
      log(e.toString());
    }
  }
}
