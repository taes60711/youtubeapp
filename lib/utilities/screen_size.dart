import 'package:flutter/material.dart';

class ScreenSize {
  Size screenSize = WidgetsBinding.instance.window.physicalSize;
  double pixelRatio =
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  double get width => screenSize.width / pixelRatio;
  double get height => screenSize.height / pixelRatio;
}
