// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/video_model.dart';
import '../utilities/keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTService {
  YTService._instantiate();
  static final YTService instance = YTService._instantiate();

  final String _baseUrl = "www.googleapis.com";
  String _nextPageToken = "";

  // Future<Channel> fetchChannel({required String channelId}) async {
  //   Map<String, String> parameters = {
  //     'part': 'snippet, contentDetails, statistics',
  //     'id': channelId,
  //     'key': API_KEY,
  //   };
  //   Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);

  //   var response = await http.get(uri);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = json.decode(response.body)['items'][0];
  //     Channel channel = Channel.fromMap(data);

  //     await fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId);

  //     return channel;
  //   } else {
  //     throw json.decode(response.body)['error']['message'];
  //   }
  // }

  Future<List<YoutubeVideo>> fetchVideosFromPlaylist({required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlistItems', parameters);

    // Get Playlist Videos
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';

      List<dynamic> videosJson = data['items'];

      List<YoutubeVideo> videos = [];
      videosJson.forEach(
        (json) => videos.add(YoutubeVideo.fromMap(json['snippet'])),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

//List<Video>
  Future<List<YoutubeVideo>> searchVideosFromKeyWord({required String keyword}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'q': keyword,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/search', parameters);

    // Get Playlist Videos
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';

      List<dynamic> videosJson = data['items'];

      List<YoutubeVideo> videos = [];

      videosJson.forEach((json) => {
            if (json['id']['kind'] == "youtube#video")
              videos.add(YoutubeVideo.fromMap(json)),
          });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

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
      final appDocDir = await getDownloadsDirectory();
      var file = File("${appDocDir?.path}/${videoInfo.title}.$fileType");
      print(file);
      var fileStream = file.openWrite();

      await stream.pipe(fileStream);
      print("Download Sucessfull");
    }
  }
}
