import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/channel_model.dart';
import '../models/video_model.dart';
import '../utilities/keys.dart';
import 'package:html/parser.dart' show parse;

class YTService {
  YTService._instantiate();

  static final YTService instance = YTService._instantiate();

  final String _baseUrl = "www.googleapis.com";
  String _nextPageToken = "";

  Future<Channel> fetchChannel({required String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      await fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId);

      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist(
      {required String playlistId}) async {
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

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(Video.fromMap(json['snippet'])),
      );

      print(videos[0].id);
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

//List<Video>
  Future<List<String>> searchVideosFromKeyWord(
      {required String keyword}) async {
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
      print(data);
      _nextPageToken = data['nextPageToken'] ?? '';

      List<dynamic> videosJson = data['items'];

      List<String> videos = [];

      videosJson.forEach((json) => {
            if (json['id']['kind'] == "youtube#video")
              videos.add(json['id']['videoId']),
          });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
