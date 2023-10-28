class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
  });

  factory YoutubeVideo.fromMap(Map<String, dynamic> json) {
    return YoutubeVideo(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
    );
  }
}
