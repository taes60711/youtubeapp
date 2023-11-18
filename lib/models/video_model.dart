class YoutubeVideo {
  final String kind;
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;

  YoutubeVideo({
    required this.kind,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
  });

  factory YoutubeVideo.fromMap(Map<String, dynamic> json, String kind) {
    String id;
    if (kind == 'video') {
      id = json['id']['videoId'];
    } else if (kind == 'channelVideo') {
      id = json['contentDetails']['videoId'];
    } else {
      id = json['id']['channelId'];
    }
    return YoutubeVideo(
      kind: kind,
      id: id,
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
      publishedAt: json['snippet']['publishedAt'],
    );
  }
}
