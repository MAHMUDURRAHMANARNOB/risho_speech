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
      accuracyScore: json['accuracyScore'].toDouble(),
      fluencyScore: json['fluencyScore'].toDouble(),
      completenessScore: json['completenessScore'].toDouble(),
      prosodyScore: json['prosodyScore'].toDouble(),
      speechText: json['speechText'],
      speechTextBn: json['speechTextbn'],
      fileLoc: json['fileLoc'],
      dialogId: json['dialogid'],
    );
  }
}
