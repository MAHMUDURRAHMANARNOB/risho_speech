import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/resetPasswordProvider.dart';
import '../../ui/colors.dart';
import '../LoginScreen.dart';

class PasswordResetScreenMobile extends StatefulWidget {
  final String? email;

  PasswordResetScreenMobile({this.email, super.key});

  @override
  State<PasswordResetScreenMobile> createState() =>
      _PasswordResetScreenMobileState();
}

class _PasswordResetScreenMobileState extends State<PasswordResetScreenMobile> {
  final TextEditingController newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final resetPassProvider = Provider.of<ResetPasswordProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter New Password",
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email Address:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: Text(
                "${widget.email}",
                softWrap: true,
              ),
            ),
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextField(
              controller: newPassController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: AppColors.primaryColor,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.password,
                  color: Colors.grey[900], // Change the color of the icon
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                hintText: 'password',
                filled: true,
                fillColor: Colors.grey[200],
                // Background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          AppColors.primaryColor), // Border color when focused
                  borderRadius:
                      BorderRadius.circular(8.0), // Border radius when focused
                ),
              ),
            ),
            const SizedBox(height: 20), // Add vertical space

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () async {
                if (widget.email!.isNotEmpty &&
                    newPassController.text.trim().isNotEmpty &&
                    newPassController.text.length >= 6) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return FutureBuilder<void>(
                        future: resetPassProvider.fetchResponse(
                          widget.email ?? '',
                          newPassController.text.trim(),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Stack(
                              children: [
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const AlertDialog(
                                  contentPadding: EdgeInsets.all(10.0),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Requesting for Resetting Password'),
                                      SpinKitThreeInOut(
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text(
                                snapshot.error.toString(),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          } else {
                            final response = resetPassProvider
                                .resetPasswordResponseDataModel;
                            if (response!.errorCode == 200) {
                              // Navigate to the login screen upon successful password reset

                              return Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        "assets/images/risho_guru_icon.png"),
                                    const Text("Success"),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        "Proceed to Login",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return AlertDialog(
                                title: Text("Error"),
                                content:
                                    Text(response.message ?? "Server Error"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text("Error"),
                      content: Text("Password should contain 6 characters"),
                    ),
                  );
                }
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
