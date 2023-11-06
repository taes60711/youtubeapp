// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/video_model.dart';
import '../utilities/keys.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTService {
  YTService._instantiate();
  static final YTService instance = YTService._instantiate();

  final String _baseUrl = "www.googleapis.com";
  String _nextPageToken = "";

  String getVideoID(String url) {
    int start = 0;
    if (url.contains('/shorts/')) {
      start = url.indexOf('/shorts/') + '/shorts/'.length;
    } else if (url.contains('/youtu.be/')) {
      start = url.indexOf('/youtu.be/') + '/youtu.be/'.length;
    } else {
      start = url.indexOf('?v=') + '?v='.length;
    }
    int end = 0;
    if (url.contains('&list')) {
      end = url.indexOf('&list');
    } else if (url.contains('?si')) {
      end = url.indexOf('?si');
    } else {
      end = url.length;
    }

    String tmpId = url.substring(start, end);
    return tmpId;
  }

  Future<List<YoutubeVideo>> searchVideosFromKeyWord(
      {required String keyword, String? mode}) async {
    Map<String, String> parameters;
    if (mode == 'URL') {
      parameters = {
        'part': 'snippet',
        'q': keyword,
        'maxResults': '30',
        'key': API_KEY,
        'regionCode': 'TW',
      };
    } else {
      parameters = {
        'part': 'snippet',
        'q': keyword,
        'maxResults': '30',
        'pageToken': _nextPageToken,
        'key': API_KEY,
        'regionCode': 'TW',
      };
    }
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/search', parameters);
    print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';
      print("data${data}");
      List<dynamic> videosJson = data['items'];

      List<YoutubeVideo> videos = [];

      videosJson.forEach((json) => {
            if (json['id']['kind'] == "youtube#video")
              {
                // if (json['id']['videoId'] != keyword)
                videos.add(YoutubeVideo.fromMap(json, 'video'))
              }
            else if (json['id']['kind'] == "youtube#channel")
              videos.add(YoutubeVideo.fromMap(json, 'channel'))
          });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<String> ytDownloader(
      YoutubeVideo videoInfo, String inputFileType) async {
    print("youtubeDownload start");
    try {
      var yt = YoutubeExplode();
      var streamInfo;
      String fileType;
      StreamManifest streamManifest =
          await yt.videos.streamsClient.getManifest(videoInfo.id);

      if (inputFileType == "mp3") {
        fileType = inputFileType;
        streamInfo = streamManifest.audioOnly.withHighestBitrate();
      } else {
        fileType = "mp4";
        streamInfo = streamManifest.muxed.withHighestBitrate();
      }
      // final int fileSize = streamInfo.size.totalBytes;

      var stream = yt.videos.streamsClient.get(streamInfo);

      const path = '/storage/emulated/0/Download';
      var filePath = File("${path}/${videoInfo.title}.$fileType");
      print(filePath);
      var fileStream = filePath.openWrite();
      await stream.pipe(fileStream);
      print("Download Sucessfull");
      return "sucessfull";
    } catch (e) {
      print(e);
      return "fail";
    }
  }
}
