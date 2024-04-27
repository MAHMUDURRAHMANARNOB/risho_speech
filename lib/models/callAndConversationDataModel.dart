class CallConversationDataModel {
  final int errorCode;
  final String message;
  final String? sessionID;
  final String? aiDialog;
  final String? aiDialogAudio;
  final String? userText;
  final String? userTextBn;
  final String? userAudio;
  final double? accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
  final double? prosodyScore;
  final String? isFemale;
  final List<WordScore>? wordScores;

  CallConversationDataModel({
    required this.errorCode,
    required this.message,
    required this.sessionID,
    required this.aiDialog,
    required this.aiDialogAudio,
    required this.userText,
    required this.userTextBn,
    required this.userAudio,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.prosodyScore,
    required this.isFemale,
    required this.wordScores,
  });

  factory CallConversationDataModel.fromJson(Map<String, dynamic> json) {
    return CallConversationDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      sessionID: json['SessionID'],
      aiDialog: json['AIDialoag'],
      aiDialogAudio: json['AIDialoagAudio'],
      userText: json['usertext'],
      userTextBn: json['usertextBn'],
      userAudio: json['useraudio'],
      accuracyScore: json['accuracyScore'].toDouble(),
      fluencyScore: json['fluencyScore'].toDouble(),
      completenessScore: json['completenessScore'].toDouble(),
      prosodyScore: json['prosodyScore'].toDouble(),
      isFemale: json['isFemale'],
      wordScores: json['wordscore'] != null
          ? List<WordScore>.from(
              json['wordscore'].map((x) => WordScore.fromJson(x)))
          : [],
    );
  }
}

class WordScore {
  final String? word;
  final int? accuracyScore;
  final String? errorType;

  WordScore({
    required this.word,
    required this.accuracyScore,
    required this.errorType,
  });

  factory WordScore.fromJson(Map<String, dynamic> json) => WordScore(
        word: json['Word'],
        accuracyScore: json['AccuracyScore'],
        errorType: json['ErrorType'],
      );
}
