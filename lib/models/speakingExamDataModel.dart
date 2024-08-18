class SpeakingExamDataModel {
  final int errorCode;
  final String message;
  final int examId;
  final String aiDialogAudio;
  final int examStage;
  final String cueCardTopics;
  final String isFemale;
  final String? report;

  SpeakingExamDataModel({
    required this.errorCode,
    required this.message,
    required this.examId,
    required this.aiDialogAudio,
    required this.examStage,
    required this.cueCardTopics,
    required this.isFemale,
    this.report,
  });

  factory SpeakingExamDataModel.fromJson(Map<String, dynamic> json) {
    return SpeakingExamDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      examId: json['examid'],
      aiDialogAudio: json['AIDialoagAudio'],
      examStage: json['examStage'],
      cueCardTopics: json['cuecardtopics'] ?? '',
      isFemale: json['isFemale'],
      report: json['report'] ??
          '', // Assuming report can be any type, adjust as needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'examid': examId,
      'AIDialoagAudio': aiDialogAudio,
      'examStage': examStage,
      'cuecardtopics': cueCardTopics,
      'isFemale': isFemale,
      'report': report,
    };
  }
}
