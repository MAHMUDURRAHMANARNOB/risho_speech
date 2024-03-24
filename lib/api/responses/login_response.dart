class LoginResponse {
  final int errorCode;
  final String message;
  final int id;
  final String userID;
  final String username;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String userType;

  LoginResponse({
    required this.errorCode,
    required this.message,
    required this.id,
    required this.userID,
    required this.username,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.userType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      errorCode: json['errorcode'],
      message: json['message'],
      id: json['id'],
      userID: json['UserID'],
      username: json['username'],
      name: json['Name'],
      email: json['Email'],
      mobile: json['Mobile'],
      password: json['Password'],
      userType: json['userType'],
    );
  }
}
