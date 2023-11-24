class YoutubeItem {
  final String? kind;
  final String? id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;

  YoutubeItem({
    this.kind,
    this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
  });

  factory YoutubeItem.fromMap(Map<String, dynamic> json, String kind) {
    String id = '';

    if (kind == 'video') {
      id = json['id']['videoId'];
    } else if (kind == 'channel') {
      id = json['id']['channelId'];
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

class ChannelItem extends YoutubeItem {
  final String? channelVideoId;
  ChannelItem(
      {required super.title,
      this.channelVideoId,
      required super.thumbnailUrl,
      required super.channelTitle,
      required super.publishedAt});

  factory ChannelItem.fromMap(Map<String, dynamic> json) {
    
    return ChannelItem(
      channelVideoId: json['contentDetails']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
      publishedAt: json['snippet']['publishedAt'],
    );
  }
}
