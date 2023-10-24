import 'package:flutter/material.dart';
import 'package:youtubeapp/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Youtube'),
        ),
        body: const Home(),
      ),
    );
  }
}
