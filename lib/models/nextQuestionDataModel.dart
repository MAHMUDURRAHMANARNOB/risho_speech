class NextQuestionDataModel {
  final int? errorCode;
  final String? message;
  final String? sessionId;
  final String? aiDialog;
  final String? aiDialogBn;
  final String? aiDialogAudio;
  final String? userText;
  final String? userTextBn;
  final String? userAudio;
  final double? pronScore;
  final double? accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
  final double? prosodyScore;
  final String? isFemale;

  NextQuestionDataModel({
    required this.errorCode,
    required this.message,
    required this.sessionId,
    required this.aiDialog,
    required this.aiDialogBn,
    required this.aiDialogAudio,
    required this.userText,
    required this.userTextBn,
    required this.userAudio,
    required this.pronScore,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.prosodyScore,
    required this.isFemale,
  });

  factory NextQuestionDataModel.fromJson(Map<String, dynamic> json) {
    return NextQuestionDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      sessionId: json['SessionID'],
      aiDialog: json['AIDialoag'],
      aiDialogBn: json['AIDialoagBn'],
      aiDialogAudio: json['AIDialoagAudio'],
      userText: json['usertext'],
      userTextBn: json['usertextBn'],
      userAudio: json['useraudio'],
      pronScore: json['pronScore'].toDouble(),
      accuracyScore: json['accuracyScore'].toDouble(),
      fluencyScore: json['fluencyScore'].toDouble(),
      completenessScore: json['completenessScore'].toDouble(),
      prosodyScore: json['prosodyScore'].toDouble(),
      isFemale: json['isFemale'],
    );
  }
}
