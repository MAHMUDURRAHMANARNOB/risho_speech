class TutorSpokenCourseResponse {
  int errorCode;
  String message;
  List<SpokenCourse> courseList;

  TutorSpokenCourseResponse({
    required this.errorCode,
    required this.message,
    required this.courseList,
  });

  // Factory method to create an instance of CourseResponse from JSON
  factory TutorSpokenCourseResponse.fromJson(Map<String, dynamic> json) {
    return TutorSpokenCourseResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      courseList: List<SpokenCourse>.from(
          json['courseList'].map((course) => SpokenCourse.fromJson(course))),
    );
  }

  // Method to convert CourseResponse instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'courseList':
          List<dynamic>.from(courseList.map((course) => course.toJson())),
    };
  }
}

class SpokenCourse {
  int courseId;
  String courseName;

  SpokenCourse({
    required this.courseId,
    required this.courseName,
  });

  // Factory method to create an instance of Course from JSON
  factory SpokenCourse.fromJson(Map<String, dynamic> json) {
    return SpokenCourse(
      courseId: json['courseid'],
      courseName: json['courseNname'],
    );
  }

  // Method to convert Course instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'courseid': courseId,
      'courseNname': courseName,
    };
  }
}
