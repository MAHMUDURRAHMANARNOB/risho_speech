import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../Common/loginForm.dart';
import '../Dashboard.dart';

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  State<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Check for stored credentials and attempt auto-login
    autoLogin();
  }

  void autoLogin() async {
    try {
      // Get stored credentials from a secure storage mechanism
      String? username = await _getStoredUsername();
      String? password = await _getStoredPassword();

      if (username != null && password != null) {
        // Call the login method from the AuthProvider
        await Provider.of<AuthProvider>(context, listen: false)
            .login(username, password);

        // Check if the user is authenticated
        if (Provider.of<AuthProvider>(context, listen: false).user != null) {
          // Navigate to the DashboardScreen on successful login
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      }
    } catch (error) {
      // Handle errors, if any
      print("Auto-login error: $error");
    } finally {
      // Set isLoading to false after auto-login attempt is finished
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getStoredUsername() async {
    // Implement this method to retrieve the stored username
    // For example, use SharedPreferences or secure storage library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> _getStoredPassword() async {
    // Implement this method to retrieve the stored password
    // For example, use SharedPreferences or secure storage library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundColorDark,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/risho_speech.png",
          width: 200,
          height: 100,
          alignment: Alignment.center,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitThreeInOut(
                color: AppColors.primaryColor,
              ), // Show loading indicator
            )
          : // Show login form when not loading
          Container(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Loginform(
                onLoginSuccess: _saveCredentials,
              ),
            ),
    );
  }

  void _saveCredentials(String username, String password) async {
    // Save the username and password using SharedPreferences
    // You can implement this similarly to how you retrieve them
    // Example:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }
}
