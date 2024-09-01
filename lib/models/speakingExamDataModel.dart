class SpeakingExamDataModel {
  final int errorCode;
  final String message;
  final int examId;
  final String? aiDialogAudio;
  final int examStage;
  final String? cueCardTopics;
  final String isFemale;
  final Report? report;

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
      report: json['report'] != null
          ? Report.fromJson(json['report'])
          : null, // Assuming report can be any type, adjust as needed
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

class Report {
  final double bandScore;
  final double pronScore;
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;
  final double prosodyScore;
  final double avgGrammarScore;
  final double vocaScore;
  final String feedbackText;

  Report({
    required this.bandScore,
    required this.pronScore,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.prosodyScore,
    required this.avgGrammarScore,
    required this.vocaScore,
    required this.feedbackText,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      bandScore: json['BandScore'] ?? 0.0,
      pronScore: json['PronScore'] ?? 0.0,
      accuracyScore: json['AccuracyScore'] ?? 0.0,
      fluencyScore: json['fluencyScore'] ?? 0.0,
      completenessScore: json['completenessScore'] ?? 0.0,
      prosodyScore: json['prosodyScore'] ?? 0.0,
      avgGrammarScore: json['avggrammarScore'] ?? 0.0,
      vocaScore: json['vocaScore'] ?? 0.0,
      feedbackText: json['feedbacktext'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BandScore': bandScore,
      'PronScore': pronScore,
      'AccuracyScore': accuracyScore,
      'fluencyScore': fluencyScore,
      'completenessScore': completenessScore,
      'prosodyScore': prosodyScore,
      'avggrammarScore': avgGrammarScore,
      'vocaScore': vocaScore,
      'feedbacktext': feedbackText,
    };
  }
}
