import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/components/listView/list_view.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/states/channel_list_state.dart';
import 'package:youtubeapp/utilities/style_config.dart';

class Channel extends StatelessWidget {
  const Channel({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    String selectedChannelId = args['selectedChannel'];

    return BlocBuilder<ChannelListCubit, ChannelListState>(
      builder: ((context, state) {
        if (state.videoItems.isNotEmpty) {
          return Scaffold(
            backgroundColor: normalBgColor,
            body: VideosListView(
              ytItems: state.videoItems,
            ),
          );
        } else {
          context.read<ChannelListCubit>().searchVideo(selectedChannelId);
          return Scaffold(
            backgroundColor: normalBgColor,
            body: const Center(
              child: LoadingWidget(
                circularSize: 70,
                strokeWidth: 10,
              ),
            ),
          );
        }
      }),
    );
  }
}
