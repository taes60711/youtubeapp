// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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
    Map<String, String> parameters;
    if (mode == 'URL') {
      parameters = {
        'part': 'snippet',
        'q': keyword,
        'maxResults': '30',
        'key': API_KEY,
        'regionCode': 'TW',
        'order': 'searchSortUnspecified'
      };
    } else {
      parameters = {
        'part': 'snippet',
        'q': keyword,
        'maxResults': '30',
        'pageToken': _nextPageToken,
        'key': API_KEY,
        'regionCode': 'TW',
        'order': 'searchSortUnspecified'
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
      // videos.sort((a, b) => (b.publishedAt).compareTo(a.publishedAt));
      videos.sort((a, b) => (a.kind!).compareTo(b.kind!));
      for (int i = 0; i < videos.length; i++) {
        print('index : ${i} data Info : ${videos[i].kind} id ${videos[i].id}');
      }

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<String> searchVideoDetail({required String videoId}) async {
    Map<String, String> parameters;
    parameters = {
      'part': 'snippet',
      'id': videoId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/videos', parameters);
    print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // print("data title ${data['items'][0]['snippet']['title']}");
      // print("data tag  ${data['items'][0]['snippet']['tags']}");
      String videoTitle = data['items'][0]['snippet']['title'];
      if (data['items'][0]['snippet']['tags'].length > 0) {
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
      print('videoTitle: ' + videoTitle);
      return videoTitle;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<YoutubeItem>> searchVideosFromChannel(
      {required String channelId}) async {
    Map<String, String> parameters;
    String playlistId =
        '${channelId.substring(0, 1)}U${channelId.substring(2)}';
    parameters = {
      'part': 'snippet&part=contentDetails',
      'key': API_KEY,
      'playlistId': playlistId,
      'maxResults': '30',
      'pageToken': _channelNextPageToken,
    };

    String url =
        'https://$_baseUrl/youtube/v3/playlistItems?part=${parameters['part']}&key=${parameters['key']}&playlistId=${parameters['playlistId']}&maxResults=${parameters['maxResults']}&pageToken=${parameters['pageToken']}';
    Uri uri = Uri.parse(url);
    print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _channelNextPageToken = data['nextPageToken'] ?? '';
      print("data${data}");
      List<YoutubeItem> videos = [];
      data['items'].forEach((json) {
        videos.add(YoutubeItem.fromMap(json, 'channelVideo'));
      });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<String> ytDownloader(
      YoutubeItem videoInfo, String inputFileType) async {
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
      String videoTitle = videoInfo.title
          .replaceAll('.', '')
          .replaceAll('/', '')
          .replaceAll('-', '');
      var filePath = File("${path}/${videoTitle}.$fileType");
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
