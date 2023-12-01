import 'package:flutter/material.dart';
import 'package:youtubeapp/components/loading.dart';
import 'package:youtubeapp/models/video_model.dart';
import 'package:youtubeapp/service/yt_service.dart';

class DownloadView extends StatefulWidget {
  DownloadView({super.key, this.selectedVideo});
  YoutubeItem? selectedVideo;

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final YTService _ytService = YTService.instance;
  int progressNum = 0;
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
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        backgroundColor: const Color.fromARGB(255, 68, 86, 147),
        elevation: 0,
      ),
      onPressed: () async {
        progressNum = 0;
        final stream = _ytService.ytDownloader(selectedVideo, downloadType);
        setState(() => isLoading['download'] = true);
        await for (int i in stream) {
          setState(() {
            progressNum = i;
          });
        }
        setState(() => isLoading['download'] = false);
      },
      child: Text(text),
    );
  }

  Widget dlButtonView(selectedVideo) {
    if (isLoading['download'] as bool) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const LoadingWidget(),
              Text(
                '$progressNum %',
                style: const TextStyle(
                    color: Color.fromARGB(255, 143, 143, 143), fontSize: 20),
              ),
            ],
          ),
        ),
      );
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
