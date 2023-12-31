import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/channel.dart';
import 'package:youtubeapp/components/playerPage/player_page.dart';
import 'package:youtubeapp/home.dart';
import 'package:youtubeapp/states/channel_list_state.dart';
import 'package:youtubeapp/states/video_list_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final VideoListCubit _videoListCubit = VideoListCubit();
final ChannelListCubit _channelListCubit = ChannelListCubit();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            }),
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => BlocProvider.value(
              value: _videoListCubit,
              child: Home(),
            ),
        '/channel': (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: _videoListCubit,
                ),
                BlocProvider.value(
                  value: _channelListCubit,
                ),
              ],
              child: Channel(),
            ),
        '/playerPage': (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: _videoListCubit,
                ),
                BlocProvider.value(
                  value: _channelListCubit,
                ),
              ],
              child: PlayerPage(),
            ),
      },
    );
  }
}
