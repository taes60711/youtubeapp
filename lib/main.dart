import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtubeapp/home.dart';
import 'package:youtubeapp/states/playerState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => VideoPlayerCubit(),
        child: Scaffold(
          body: Home(),
        ),
      ),
    );
  }
}
