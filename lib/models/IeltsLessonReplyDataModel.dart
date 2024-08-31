class IeltsLessonReplyDataModel {
  final int errorCode;
  final String message;
  final String answerText;
  final String sessionId;

  IeltsLessonReplyDataModel({
    required this.errorCode,
    required this.message,
    required this.answerText,
    required this.sessionId,
  });

  // Factory constructor to create an instance from JSON
  factory IeltsLessonReplyDataModel.fromJson(Map<String, dynamic> json) {
    return IeltsLessonReplyDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      answerText: json['answertext'],
      sessionId: json['SessonID'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'answertext': answerText,
      'SessonID': sessionId,
    };
  }
}
