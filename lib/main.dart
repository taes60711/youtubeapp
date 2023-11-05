import 'package:flutter/material.dart';
import 'package:youtubeapp/home.dart';
import 'package:youtubeapp/playerPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Home(),
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/playerPage': (BuildContext context) =>
            playerPage(arguments: ModalRoute.of(context)?.settings.arguments)
      },
    );
  }
}
