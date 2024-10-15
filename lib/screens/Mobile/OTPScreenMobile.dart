import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/createUserProvider.dart';
import '../../ui/colors.dart';
import '../Common/error_dialog.dart';
import '../dashboard.dart';

class OtpScreenMobile extends StatefulWidget {
  static const String id = "otp_screen";
  final int? otp;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? mobile;
  final String? password;

  OtpScreenMobile(
      {Key? key,
      this.otp,
      this.userName,
      this.fullName,
      this.email,
      this.mobile,
      this.password})
      : super(key: key);

  @override
  State<OtpScreenMobile> createState() => _OtpScreenMobileState();
}

class _OtpScreenMobileState extends State<OtpScreenMobile> {
  late String? otpCode;

  @override
  Widget build(BuildContext context) {
    if (widget.otp == null) {
      // Handle the case where otp is null, for example, show a loading indicator
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    print(widget.otp);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text(
          "Authentication",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Text(
              "CO\nDE",
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Mina"),
            ),*/
            Image.asset(
              "assets/images/otp_avatar.png",
              width: double.infinity,
              height: 200,
            ),
            Text(
              "Verification",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("We have sent you the verification code to - "),
            SizedBox(height: 10),
            Text(widget.email!),
            SizedBox(height: 10),
            OtpTextField(
              numberOfFields: 4,
              fillColor: AppColors.primaryCardColor,
              filled: true,
              keyboardType: TextInputType.number,
              borderWidth: 0.5,
              focusedBorderColor: AppColors.primaryColor,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              /*onCodeChanged: (String code) {
                //handle validation or checks here
              },*/
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                setState(() {
                  otpCode = verificationCode;
                });
              }, // end onSubmit
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.all(15.0),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Set to false to make it non-cancelable
                    builder: (BuildContext context) {
                      return Stack(
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.black
                                  .withOpacity(0.5), // Adjust opacity as needed
                            ),
                          ),
                          AlertDialog(
                            contentPadding: EdgeInsets.all(10.0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Matching OTP'),
                                SpinKitThreeInOut(
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  if (otpCode == widget.otp.toString()) {
                    final response = await Provider.of<UserCreationProvider>(
                            context,
                            listen: false)
                        .createUser(
                            // Pass parameters for user creation
                            widget.userName!,
                            widget.userName!,
                            widget.fullName!,
                            widget.email!,
                            widget.mobile!,
                            widget.password!,
                            "S",
                            "not-mentioned",
                            "not-mentioned",
                            "not-mentioned");

                    print("Response is: ${response}");

                    if (response == true) {
                      /*showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Success"),
                          content: Text(
                              'User created successfully! Logging you in...'),
                        ),
                      );*/
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Set to false to make it non-cancelable
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adjust opacity as needed
                                ),
                              ),
                              AlertDialog(
                                title: Center(child: Text("Success")),
                                contentPadding: EdgeInsets.all(10.0),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'User created successfully! Logging you in'),
                                    SpinKitThreeInOut(
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      try {
                        // Call the login method from the AuthProvider
                        await Provider.of<AuthProvider>(context, listen: false)
                            .login(widget.email!, widget.password!, "N");

                        // Check if the user is authenticated
                        if (Provider.of<AuthProvider>(context, listen: false)
                                .user !=
                            null) {
                          // Navigate to the DashboardScreen on successful login
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                            (route) => false,
                          );
                        } else {
                          // Handle unsuccessful login
                          print("Login failed");
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message:
                                    "Login failed, check username and password.",
                              );
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
                    } else if (response == false) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              'User Already exist, either user id, mobile,email matched with other user'),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text('Unexpected response format.'),
                        ),
                      );
                    }
                  } else {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text('OTP did not match'),
                      ),
                    );
                  }
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
