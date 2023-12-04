abstract class Item {
  String title;
  String thumbnailUrl;
  String channelTitle;
  String publishedAt;
  Item(
      {required this.title,
      required this.thumbnailUrl,
      required this.channelTitle,
      required this.publishedAt});
}

class YoutubeItem extends Item {
  final String? kind;
  late final String? id;

  YoutubeItem(
      {this.kind,
      this.id,
      required super.title,
      required super.thumbnailUrl,
      required super.channelTitle,
      required super.publishedAt});

  factory YoutubeItem.fromMap(Map<String, dynamic> json, String kind) {
    String id = '';

    if (kind == 'video') {
      id = json['id']['videoId'];
    } else if (kind == 'channel') {
      id = json['id']['channelId'];
    } else if (kind == 'channel_video') {
      id = json['contentDetails']['videoId'];
    }

    return YoutubeItem(
      kind: kind,
      id: id,
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
      publishedAt: json['snippet']['publishedAt'],
    );
  }
}

// class ChannelItem extends Item {
//   final String? channelVideoId;
//   ChannelItem(
//       {this.channelVideoId,
//       required super.title,
//       required super.thumbnailUrl,
//       required super.channelTitle,
//       required super.publishedAt});

//   factory ChannelItem.fromMap(Map<String, dynamic> json) {
//     return ChannelItem(
//       channelVideoId: json['contentDetails']['videoId'],
//       title: json['snippet']['title'],
//       thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
//       channelTitle: json['snippet']['channelTitle'],
//       publishedAt: json['snippet']['publishedAt'],
//     );
//   }
// }
