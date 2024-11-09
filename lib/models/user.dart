class AppUser {
  final int id;
  final String userID;
  final String? username;
  final String? name;
  final String? email;
  final String? mobile;
  final String? password;
  final String? userType;

  AppUser(
      {required this.id,
      required this.userID,
      this.username,
      this.name,
      this.email,
      this.mobile,
      this.password,
      this.userType});
}
