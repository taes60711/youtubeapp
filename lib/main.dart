import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/channel.dart';
import 'package:youtubeapp/components/playerPage/playerPage.dart';
import 'package:youtubeapp/home.dart';
import 'package:youtubeapp/states/videoListState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: BlocProvider(
        create: (_) => VideoListCubit(),
        child: Scaffold(
          body: Home(),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(),
        '/channel': (BuildContext context) => const Channel(),
        '/playerPage': (BuildContext context) => const playerPage(),
      },
    );
  }
}
