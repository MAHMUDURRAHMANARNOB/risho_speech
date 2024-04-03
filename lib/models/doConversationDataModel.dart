class DoConversationDataModel {
  final int? errorCode;
  final String? message;
  final String? sessionId;
  final String? aiDialogue;
  final String? aiDialogueAudio;
  final String? userText;
  final String? userTextBn;
  final String? userAudio;
  final double? accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
  final double? prosodyScore;

  DoConversationDataModel({
    required this.errorCode,
    required this.message,
    required this.sessionId,
    required this.aiDialogue,
    required this.aiDialogueAudio,
    required this.userText,
    required this.userTextBn,
    required this.userAudio,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.prosodyScore,
  });

  factory DoConversationDataModel.fromJson(Map<String, dynamic> json) {
    return DoConversationDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      sessionId: json['SessionID'],
      aiDialogue: json['AIDialoag'],
      aiDialogueAudio: json['AIDialoagAudio'],
      userText: json['usertext'],
      userTextBn: json['usertextBn'],
      userAudio: json['useraudio'],
      accuracyScore: json['accuracyScore'] != null
          ? json['accuracyScore'].toDouble()
          : json['accuracyScore'],
      fluencyScore: json['fluencyScore'] != null
          ? json['fluencyScore'].toDouble()
          : json['fluencyScore'],
      completenessScore: json['completenessScore'] != null
          ? json['completenessScore'].toDouble()
          : json['completenessScore'],
      prosodyScore: json['prosodyScore'] != null
          ? json['prosodyScore'].toDouble()
          : json['prosodyScore'],
    );
  }
}
