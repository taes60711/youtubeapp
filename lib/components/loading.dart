import 'package:flutter/material.dart';
import 'package:youtubeapp/utilities/style_config.dart';

class LoadingWidget extends StatelessWidget {
  double? circularSize;
  double? strokeWidth;
  Color? backgroundColor;
  Color? strokeColor;
  LoadingWidget(
      {super.key,
      this.circularSize,
      this.strokeWidth,
      this.backgroundColor,
      this.strokeColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(8.0),
      child: SizedBox(
        height: circularSize ?? 50,
        width: circularSize ?? 50,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 5,
          backgroundColor: backgroundColor ?? normalBgColor,
          color: strokeColor ?? normalTextColor,
        ),
      ),
    );
  }
}
