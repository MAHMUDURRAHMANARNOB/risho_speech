class OtpResponse {
  final int errorCode;
  final String message;
  final int otp;

  OtpResponse({
    required this.errorCode,
    required this.message,
    required this.otp,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      errorCode: json['errorCode'],
      message: json['message'],
      otp: json['otp'],
    );
  }
}
