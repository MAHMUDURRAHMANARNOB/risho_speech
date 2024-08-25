class VideoLesson {
  final int lessonId;
  final int courseId;
  final String lessonTitle;

  VideoLesson({
    required this.lessonId,
    required this.courseId,
    required this.lessonTitle,
  });

  factory VideoLesson.fromJson(Map<String, dynamic> json) {
    return VideoLesson(
      lessonId: json['lessonId'],
      courseId: json['Courseid'],
      lessonTitle: json['lessonTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'Courseid': courseId,
      'lessonTitle': lessonTitle,
    };
  }
}

class IeltsCourseLessonListDataModel {
  final int errorCode;
  final String message;
  final List<VideoLesson> videoList;

  IeltsCourseLessonListDataModel({
    required this.errorCode,
    required this.message,
    required this.videoList,
  });

  factory IeltsCourseLessonListDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['videolist'] as List;
    List<VideoLesson> videoList =
        list.map((i) => VideoLesson.fromJson(i)).toList();

    return IeltsCourseLessonListDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      videoList: videoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'videolist': videoList.map((v) => v.toJson()).toList(),
    };
  }
}
