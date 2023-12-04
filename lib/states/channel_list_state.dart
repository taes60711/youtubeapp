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

class AddLoadingState extends ChannelListState {
  AddLoadingState({required List<YoutubeItem> videoItems})
      : super(videoItems: videoItems);
}

class SearchSuccesState extends ChannelListState {
  SearchSuccesState(List<YoutubeItem> videoItems, String channelId)
      : super(videoItems: videoItems);
}

class ChannelListCubit extends Cubit<ChannelListState> {
  String? channelId;
  ChannelListCubit({this.channelId}) : super(ListInitialState(videoItems: []));
  final YTService _ytService = YTService.instance;

  Future<void> searchVideo(String channelId,
      {List<YoutubeItem>? videoItems}) async {

    doSearchORAddVideos(void emits, String channelId,
        {List<YoutubeItem>? videoItems}) async {
      emits;
      try {
        List<YoutubeItem> searchResult =
            await _ytService.searchVideosFromChannel(channelId: channelId);
        List<YoutubeItem> returnVideoItems = (videoItems ?? [])
          ..addAll(searchResult);

        emit(SearchSuccesState(returnVideoItems, channelId));
      } catch (error) {
        print('$error');
        rethrow;
      }
    }

    this.channelId = channelId;
    if (videoItems != null) {
      doSearchORAddVideos(
          emit(AddLoadingState(videoItems: videoItems)), channelId,
          videoItems: videoItems);
    } else {
      doSearchORAddVideos(emit(LoadingState()), channelId);
    }
  }
}
