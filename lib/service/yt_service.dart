// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/video_model.dart';
import '../utilities/keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:external_path/external_path.dart';

class YTService {
  YTService._instantiate();
  static final YTService instance = YTService._instantiate();

  final String _baseUrl = "www.googleapis.com";
  String _nextPageToken = "";

  Future<List<YoutubeVideo>> searchVideosFromKeyWord({required String keyword}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'q': keyword,
      'maxResults': '30',
      'pageToken': _nextPageToken,
      'key': API_KEY,
      'regionCode': 'TW',
    };
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
              videos.add(YoutubeVideo.fromMap(json, 'video'))
            else if (json['id']['kind'] == "youtube#channel")
              videos.add(YoutubeVideo.fromMap(json, 'channel'))
          });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

//YoutubeVideo videoInfo, String inputFileType
  Future ytDownloader(YoutubeVideo videoInfo, String inputFileType) async {
    print("youtubeDownload start");
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

    print("streamInfo ${streamInfo}");
    var stream = yt.videos.streamsClient.get(streamInfo);

    if (stream != null) {
      final appDocDir = '/storage/emulated/0/Download'; //await getDownloadsDirectory();
      // await ExternalPath.getExternalStoragePublicDirectory(
      //     ExternalPath.DIRECTORY_DOWNLOADS);
      var file = File("${appDocDir}/${videoInfo.title}.$fileType");
      print(file);
      var fileStream = file.openWrite();

      await stream.pipe(fileStream);
      print("Download Sucessfull");
    }
  }
}
