import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:risho_speech/screens/RegistrationScreen.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../ui/colors.dart';
import '../Dashboard.dart';
import '../forget_pass_screen.dart';
import 'error_dialog.dart';

class Loginform extends StatefulWidget {
  final Function(String, String) onLoginSuccess; //Callback function

  const Loginform({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  // Initially hide the password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryColor.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 60,
                height: 1,
                fontFamily: 'Smooch',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "We are glad to see you back with us",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            /*EMAIL INPUT BOX*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username / Email / Phone",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_2_outlined,
                      color: Colors.grey[900], // Change the color of the icon
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    hintText: 'Your Username, Email or Phone',
                    filled: true,
                    fillColor: Colors.grey[200],
                    // Background color
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors
                              .primaryColor), // Border color when focused
                      borderRadius: BorderRadius.circular(
                          8.0), // Border radius when focused
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Add vertical space
            /*Password input box*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  cursorColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.grey[900], // Change the color of the icon
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    /*labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[400]),*/
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: 'Your Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    // Background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors
                              .primaryColor), // Border color when focused
                      borderRadius: BorderRadius.circular(
                          10.0), // Border radius when focused
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  obscureText: _obscureText,
                ),
              ],
            ),
            const SizedBox(height: 5),
            /*Forget pass*/
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPassScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Add vertical space
            /*Login btn*/
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 10.0,
                shadowColor: AppColors.primaryColor.withOpacity(0.1),
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false, // Prevent dialog dismissal
                  builder: (BuildContext context) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: Colors.green,
                      ), // Show loader
                    );
                  },
                );
                try {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  // Call the login method from the AuthProvider
                  await Provider.of<AuthProvider>(context, listen: false)
                      .login(username, password, "N");
                  Navigator.pop(context);
                  // Check if the user is authenticated
                  if (Provider.of<AuthProvider>(context, listen: false).user !=
                      null) {
                    AppUser user =
                        Provider.of<AuthProvider>(context, listen: false).user!;
                    print("User ID: ${user.userID}");
                    print("Username: ${user.username}");

                    // Navigate to the DashboardScreen on successful login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                    widget.onLoginSuccess(username, password);
                  } else {
                    // Handle unsuccessful login
                    print("Login failed");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                            message:
                                "Login failed, \nCheck username and password.");
                      },
                    );
                  }
                } catch (error) {
                  // Handle errors from the API call or login process
                  print("Error during login: $error");
                  // Show the custom error dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(message: error.toString());
                    },
                  );
                }
              },
              /*onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ),
                );
              },*/
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minWidth: 100.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 1.0,
                      width: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' with Others',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 1.0,
                      width: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: IconButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        // Prevent dismissal by tapping outside
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 20),
                              Text("Signing in..."), // Loading message
                            ],
                          ),
                        ),
                      );
                      try {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .signInWithGoogle(context);
                        // AuthProvider().signInWithGoogle(context);
                        // Remove the loading dialog
                        Navigator.pop(context);

                        AppUser? user =
                            Provider.of<AuthProvider>(context, listen: false)
                                .user;

                        if (user != null) {
                          // Login success, navigate to Dashboard
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                          );
                          // widget.onLoginSuccess(username, password);
                        } else {
                          // Handle unsuccessful login
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message:
                                    "Login failed, \nCheck username and password.",
                              );
                            },
                          );
                        }
                      } catch (error) {
                        // Handle errors
                        Navigator.pop(context);
                        // Handle errors during sign-in
                        print("Error during Google sign-in: $error");

                        // Show an error dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message:
                                  "An error occurred during sign-in: $error",
                            );
                          },
                        );
                        // Show an error dialog if needed
                      }
                    },
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/com_icon/google_icon.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Visibility(
                  visible: Platform.isIOS,
                  child: Center(
                    child: IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          // Prevent dismissal by tapping outside
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 20),
                                Text("Signing in..."), // Loading message
                              ],
                            ),
                          ),
                        );
                        try {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .signInWithApple(context);
                          // AuthProvider().signInWithGoogle(context);
                          // Remove the loading dialog
                          Navigator.pop(context);

                          AppUser? user =
                              Provider.of<AuthProvider>(context, listen: false)
                                  .user;

                          if (user != null) {
                            // Login success, navigate to Dashboard
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()),
                            );
                            // widget.onLoginSuccess(username, password);
                          } else {
                            // Handle unsuccessful login
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: "Login failed. Please Try Again",
                                );
                              },
                            );
                          }
                        } catch (error) {
                          // Handle errors
                          Navigator.pop(context);
                          // Handle errors during sign-in
                          print("Error during Google sign-in: $error");

                          // Show an error dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message:
                                    "An error occurred during sign-in: $error",
                              );
                            },
                          );
                          // Show an error dialog if needed
                        }
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/com_icon/apple_icon.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            /*Signup*/
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.secondaryColor.withOpacity(0.1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign-up',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
