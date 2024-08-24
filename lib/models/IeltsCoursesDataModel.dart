class Courses {
  final int courseId;
  final String courseTitle;
  final String? coverUrl;

  Courses({
    required this.courseId,
    required this.courseTitle,
    this.coverUrl,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      courseId: json['courseid'],
      courseTitle: json['courseTitle'],
      coverUrl: json['coverurl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseid': courseId,
      'courseTitle': courseTitle,
      'coverurl': coverUrl,
    };
  }
}

class Ieltscoursesdatamodel {
  final int errorCode;
  final String message;
  final List<Courses> videoList;

  Ieltscoursesdatamodel({
    required this.errorCode,
    required this.message,
    required this.videoList,
  });

  factory Ieltscoursesdatamodel.fromJson(Map<String, dynamic> json) {
    var list = json['videolist'] as List;
    List<Courses> videoList = list.map((i) => Courses.fromJson(i)).toList();

    return Ieltscoursesdatamodel(
      errorCode: json['errorcode'],
      message: json['message'],
      videoList: videoList,
    );
  }
}
