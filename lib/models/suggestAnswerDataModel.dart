class SuggestAnswerDataModel {
  final int? errorCode;
  final String? message;
  final String? replyText;

  SuggestAnswerDataModel({
    required this.errorCode,
    required this.message,
    required this.replyText,
  });

  factory SuggestAnswerDataModel.fromJson(Map<String, dynamic> json) {
    return SuggestAnswerDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      replyText: json['replyText'],
    );
  }
}
