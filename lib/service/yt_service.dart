// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:youtubeapp/models/video_model.dart';
import '../utilities/keys.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTService {
  YTService._instantiate();
  static final YTService instance = YTService._instantiate();

  final String _baseUrl = "www.googleapis.com";
  String _nextPageToken = "";
  String _channelNextPageToken = '';

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

  Future<List<YoutubeItem>> searchVideosFromKeyWord(
      {required String keyword, String? mode}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'q': keyword,
      'maxResults': '30',
      'key': API_KEY,
      'regionCode': 'TW',
      'order': 'searchSortUnspecified'
    };
    if (mode == 'URL') {
      parameters.containsKey('pageToken') ? parameters.remove('pageToken') : '';
    } else {
      parameters['pageToken'] = _nextPageToken;
    }

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/search', parameters);

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';
      log("search Result : $data");
      List<dynamic> videosJson = data['items'];

      List<YoutubeItem> videos = [];

      videosJson.forEach((json) => {
            if (json['id']['kind'] == "youtube#video")
              {
                // if (json['id']['videoId'] != keyword)
                videos.add(YoutubeItem.fromMap(json, 'video'))
              }
            else if (json['id']['kind'] == "youtube#channel")
              videos.add(YoutubeItem.fromMap(json, 'channel'))
          });

      videos.sort((a, b) => (a.kind!).compareTo(b.kind!));
      // for (int i = 0; i < videos.length; i++) {
      //   print('index : $i data Info : ${videos[i].kind} id ${videos[i].id}');
      // }

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<String> searchVideoDetail({required String videoId}) async {
    Map<String, String>  parameters = {
      'part': 'snippet',
      'id': videoId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/videos', parameters);
    print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String videoTitle = data['items'][0]['snippet']['title'];
      if (data['items'][0]['snippet']['tags'] != null) {
        if (data['items'][0]['snippet']['tags'].length > 4) {
          for (int i = 0; i < 4; i++) {
            videoTitle += data['items'][0]['snippet']['tags'][i] + ' ';
          }
        } else {
          data['items'][0]['snippet']['tags'].forEach((tag) => {
                videoTitle += tag + ' ',
              });
        }
      } else {
        videoTitle = data['items'][0]['snippet']['title'];
      }
      print('videoTitle: $videoTitle');
      return videoTitle;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<YoutubeItem>> searchVideosFromChannel(
      {required String channelId}) async {
    String playlistId =
        '${channelId.substring(0, 1)}U${channelId.substring(2)}';
    Map<String, String> parameters = {
      'part': 'snippet&part=contentDetails',
      'key': API_KEY,
      'playlistId': playlistId,
      'maxResults': '30',
      'pageToken': _channelNextPageToken,
    };

    String url =
        'https://$_baseUrl/youtube/v3/playlistItems?part=${parameters['part']}'
        '&key=${parameters['key']}'
        '&playlistId=${parameters['playlistId']}'
        '&maxResults=${parameters['maxResults']}'
        '&pageToken=${parameters['pageToken']}';
    Uri uri = Uri.parse(url);
    print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _channelNextPageToken = data['nextPageToken'] ?? '';
      log("search Result : $data");
      List<YoutubeItem> videos = [];
      data['items'].forEach((json) {
        videos.add(YoutubeItem.fromMap(json, 'channel_video'));
      });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Stream<int> ytDownloader(YoutubeItem videoInfo, String inputFileType) async* {
    print("youtubeDownload start");

    var yt = YoutubeExplode();
    dynamic streamInfo;
    int fileSize = 0;
    String fileType = inputFileType;
    StreamManifest streamManifest =
        await yt.videos.streamsClient.getManifest(videoInfo.id);

    if (inputFileType == "mp3") {
      streamInfo = streamManifest.audioOnly.withHighestBitrate();
      fileSize = streamManifest.audioOnly.last.size.totalBytes;
    } else {
      streamInfo = streamManifest.muxed.withHighestBitrate();
      fileSize = streamManifest.muxed.last.size.totalBytes;
    }


    String path = '';
    if (Platform.isAndroid) {
      path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      //'/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      path = appDocDir.path;
    }

    String videoTitle = videoInfo.title
        .replaceAll('.', '')
        .replaceAll('/', '')
        .replaceAll('-', '');

    File filePath = File("$path/$videoTitle.$fileType");
    print('DownLoad File Path :$filePath ');

    var stream = yt.videos.streamsClient.get(streamInfo);
    var count = 0;
    var fileStream = filePath.openWrite();
    await for (final data in stream) {
      count += data.length;
      print('count $count , length $fileSize ${(count / fileSize)}');
      var progress = ((count / fileSize) * 100).ceil();
      yield progress;
      fileStream.add(data);
    }
    await fileStream.close();
    print("Download Sucessfull");
  }
}
