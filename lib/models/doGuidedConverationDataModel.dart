class DoGuidedConversationDataModel {
  final int error;
  final String message;
  final int? convid;
  final String? actorName;
  final String? conversationEn;
  final String? conversationBn;
  final String? conversationAudioFile;
  final int? seqNumber;
  final String? isFirst;
  final String? isLast;
  final String? conversationDetails;
  final String? discussionTopic;
  final String? discusTitle;
  final double? accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
  final double? prosodyScore;
  final String? speechText;
  final String? speechTextBn;
  final String? fileLoc;
  final int? dialogId;
  final List<WordInfo>? words;

  DoGuidedConversationDataModel({
    required this.error,
    required this.message,
    required this.convid,
    required this.actorName,
    required this.conversationEn,
    required this.conversationBn,
    required this.conversationAudioFile,
    required this.seqNumber,
    required this.isFirst,
    required this.isLast,
    required this.conversationDetails,
    required this.discussionTopic,
    required this.discusTitle,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.prosodyScore,
    required this.speechText,
    required this.speechTextBn,
    required this.fileLoc,
    required this.dialogId,
    required this.words,
  });

  factory DoGuidedConversationDataModel.fromJson(Map<String, dynamic> json) {
    return DoGuidedConversationDataModel(
      error: json['error'],
      message: json['message'],
      convid: json['convid'],
      actorName: json['actorName'],
      conversationEn: json['conversationEn'],
      conversationBn: json['conversationBn'],
      conversationAudioFile: json['conversationAudioFile'],
      seqNumber: json['seqNumber'],
      isFirst: json['isFirst'],
      isLast: json['islast'],
      conversationDetails: json['conversationDetails'],
      discussionTopic: json['discussionTopic'],
      discusTitle: json['discusTitle'],
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
      speechText: json['speechText'],
      speechTextBn: json['speechTextbn'],
      fileLoc: json['fileLoc'],
      dialogId: json['dialogid'],
      words: json['words'] != null
          ? List<WordInfo>.from(json['words'].map((x) => WordInfo.fromJson(x)))
          : [],
    );
  }
}

class WordInfo {
  final String word;
  final double accuracyScore;
  final String? errorType;

  WordInfo({
    required this.word,
    required this.accuracyScore,
    required this.errorType,
  });

  factory WordInfo.fromJson(Map<String, dynamic> json) {
    return WordInfo(
      word: json['Word'],
      accuracyScore: json['AccuracyScore'],
      errorType: json['ErrorType'],
    );
  }
}
