import 'package:flutter/material.dart';

class loadingWidget extends StatelessWidget {
  const loadingWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          backgroundColor: Colors.black26,
          color: Colors.black26,
        ),
      ),
    );
  }
}