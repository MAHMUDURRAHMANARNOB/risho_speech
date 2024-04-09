class SuccessfulResponse {
  final int errorCode;
  final String message;
  final int userId;

  SuccessfulResponse({
    required this.errorCode,
    required this.message,
    required this.userId,
  });

  factory SuccessfulResponse.fromJson(Map<String, dynamic> json) {
    return SuccessfulResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      userId: json['userid'],
    );
  }
}

class ErrorResponse {
  final int errorCode;
  final String message;
  final String userId;
  final String hash;

  ErrorResponse({
    required this.errorCode,
    required this.message,
    required this.userId,
    required this.hash,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      userId: json['userid'],
      hash: json['hash'],
    );
  }
}
