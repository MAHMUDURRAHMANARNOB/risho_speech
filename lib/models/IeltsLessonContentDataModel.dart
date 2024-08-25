class Video {
  final int videoId;
  final int lessonId;
  final String videoTitle;
  final String videoDuration;
  final String videoUrl;

  Video({
    required this.videoId,
    required this.lessonId,
    required this.videoTitle,
    required this.videoDuration,
    required this.videoUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['videoid'],
      lessonId: json['lessonid'],
      videoTitle: json['videoTitle'],
      videoDuration: json['videoduration'],
      videoUrl: json['videourl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoid': videoId,
      'lessonid': lessonId,
      'videoTitle': videoTitle,
      'videoduration': videoDuration,
      'videourl': videoUrl,
    };
  }
}

class LessonContentDataModel {
  final int errorCode;
  final String message;
  final int lessonAnsId;
  final String lessonContent;
  final List<Video> videoList;

  LessonContentDataModel({
    required this.errorCode,
    required this.message,
    required this.lessonAnsId,
    required this.lessonContent,
    required this.videoList,
  });

  factory LessonContentDataModel.fromJson(Map<String, dynamic> json) {
    var videoListJson = json['videolist'] as List;
    List<Video> videoList =
        videoListJson.map((i) => Video.fromJson(i)).toList();

    return LessonContentDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      lessonAnsId: json['lessonAnsId'],
      lessonContent: json['lessonContent'],
      videoList: videoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'lessonAnsId': lessonAnsId,
      'lessonContent': lessonContent,
      'videolist': videoList.map((v) => v.toJson()).toList(),
    };
  }
}
