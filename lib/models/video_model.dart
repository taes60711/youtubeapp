

class YoutubeItem  {
  final String? kind;
  late final String? id;
  String title;
  String thumbnailUrl;
  String channelTitle;
  String publishedAt;

  YoutubeItem(
      {this.kind,
      this.id,
      required this.title,
      required this.thumbnailUrl,
      required this.channelTitle,
      required this.publishedAt});

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

