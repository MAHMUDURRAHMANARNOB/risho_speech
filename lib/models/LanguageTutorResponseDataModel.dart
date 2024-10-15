// Model for successful response
import 'package:risho_speech/models/languageListDataModel.dart';

class LanguageTutorSuccessResponse {
  final int errorCode;
  final String message;
  final String sessionID;
  final String aiDialogue;
  final String aiDialogueAudio;
  final String lessonTitle;
  final String chapterTitle;
  final int lessonCount;
  final String userText;
  final String userAudioFile;

  LanguageTutorSuccessResponse({
    required this.errorCode,
    required this.message,
    required this.sessionID,
    required this.aiDialogue,
    required this.aiDialogueAudio,
    required this.lessonTitle,
    required this.chapterTitle,
    required this.lessonCount,
    required this.userText,
    required this.userAudioFile,
  });

  factory LanguageTutorSuccessResponse.fromJson(Map<String, dynamic> json) {
    return LanguageTutorSuccessResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      sessionID: json['SessionID'],
      aiDialogue: json['AIDialoag'],
      aiDialogueAudio: json['AIDialoagAudio'],
      lessonTitle: json['lessonTitle'],
      chapterTitle: json['chapterTitle'],
      lessonCount: json['lessoncount'],
      userText: json['userText'] ?? "",
      userAudioFile: json['userAudioFile'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'SessionID': sessionID,
      'AIDialoag': aiDialogue,
      'AIDialoagAudio': aiDialogueAudio,
      'lessonTitle': lessonTitle,
      'chapterTitle': chapterTitle,
      'lessoncount': lessonCount,
      'userText': userText,
      'userAudioFile': userAudioFile,
    };
  }
}

// Model for error response (no course selected)
class LanguageTutorNotSelectedResponse {
  final int errorCode;
  final String message;
  final List<LanguageCourse> courseList;

  LanguageTutorNotSelectedResponse({
    required this.errorCode,
    required this.message,
    required this.courseList,
  });

  factory LanguageTutorNotSelectedResponse.fromJson(Map<String, dynamic> json) {
    var courseList = (json['courseList'] as List)
        .map((course) => LanguageCourse.fromJson(course))
        .toList();

    return LanguageTutorNotSelectedResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      courseList: courseList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'courseList': courseList.map((course) => course.toJson()).toList(),
    };
  }
}

// Model for individual course in the course list
class LanguageCourse {
  final int courseId;
  final String courseName;

  LanguageCourse({
    required this.courseId,
    required this.courseName,
  });

  factory LanguageCourse.fromJson(Map<String, dynamic> json) {
    return LanguageCourse(
      courseId: json['courseid'],
      courseName: json['courseNname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseid': courseId,
      'courseNname': courseName,
    };
  }
}
