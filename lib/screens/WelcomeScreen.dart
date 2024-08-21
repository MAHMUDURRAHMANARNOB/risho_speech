import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/LoginScreen.dart';
import 'package:risho_speech/screens/RegistrationScreen.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import 'Dashboard.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorDark,
        body: _isLoading
            ? AlertDialog(
                contentPadding: EdgeInsets.all(10.0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/risho_guru_icon.png",
                      width: 80,
                      height: 80,
                    ),
                    SpinKitThreeInOut(
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/risho_guru_icon.png",
                            height: 150,
                          ),
                          const Text(
                            "RISHO",
                            style: TextStyle(
                              fontFamily: "Potta",
                              fontSize: 40,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const Text(
                            "SPEECH",
                            style: TextStyle(
                              fontFamily: "Potta",
                              fontSize: 40,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Your Personal AI English Speaking Coach",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  "Log-In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(
                                    width: 2.0,
                                    color: AppColors.primaryColor,
                                  )),
                              child: Container(
                                width: double.infinity,
                                child: const Text(
                                  "Sign-Up",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            child: const Text(
                              "By using Risho-Speech you will agree to out Terms and Privacy Policy",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
