import 'package:flutter/material.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

class DownloadView extends StatefulWidget {
  DownloadView({super.key,  this.selectedVideo});
  YoutubeItem? selectedVideo;

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final YTService _ytService = YTService.instance;
  Map<String, bool> isLoading = {
    'download': false,
  };

  Future<void> loadingChange(
      String loadingtype, Function fun, List<dynamic> params) async {
    setState(() => isLoading[loadingtype] = true);
    await Function.apply(fun, params);
    setState(() => isLoading[loadingtype] = false);
  }

  Widget dlerButton(
      String text, String downloadType, YoutubeItem selectedVideo) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () async => {
        loadingChange(
            'download', _ytService.ytDownloader, [selectedVideo, downloadType]),
      },
    );
  }

  Widget dlButtonView(selectedVideo) {
    if (isLoading['download'] as bool) {
      return const LoadingWidget();
    } else {
      return Column(
        children: [
          dlerButton('Download Mp4', "mp4", selectedVideo),
          dlerButton('Download Mp3', "mp3", selectedVideo),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return dlButtonView(widget.selectedVideo);
  }
}
