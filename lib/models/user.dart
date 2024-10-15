class AppUser {
  final int id;
  final String userID;
  final String username;
  final String name;
  final String email;
  final String mobile;
  final String? password;
  final String userType;

  AppUser(
      {required this.id,
      required this.userID,
      required this.username,
      required this.name,
      required this.email,
      required this.mobile,
      this.password,
      required this.userType});
}
