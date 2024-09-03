class ShonodAiResponseDataModel {
  final int errorCode;
  final String message;
  final String? answer;
  final String? sessionID;

  ShonodAiResponseDataModel({
    required this.errorCode,
    required this.message,
    this.answer,
    this.sessionID,
  });

  // Factory constructor to create an instance from JSON
  factory ShonodAiResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ShonodAiResponseDataModel(
      errorCode: json['errorcode'],
      message: json['message'],
      answer: json['answer'] ?? "",
      sessionID: json['sessionID'] ?? "",
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorCode,
      'message': message,
      'answer': answer,
      'sessionID': sessionID,
    };
  }
}
