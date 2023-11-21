import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          backgroundColor: Color.fromARGB(31, 162, 162, 162),
          color: Color.fromARGB(255, 143, 143, 143),
        ),
      ),
    );
  }
}