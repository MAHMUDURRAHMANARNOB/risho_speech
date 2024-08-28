import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../ui/colors.dart';
import '../password_reset_screen.dart';

class EmailVerificationOTPScreenMobile extends StatefulWidget {
  final int? otp;
  final String? email;
  final String? mobile;

  /*EmailVerificationOTPScreenMobile({super.key});*/
  EmailVerificationOTPScreenMobile({
    Key? key,
    this.otp,
    this.email,
    this.mobile,
  }) : super(key: key);

  @override
  State<EmailVerificationOTPScreenMobile> createState() =>
      _EmailVarificationOTPScreenMobileState();
}

class _EmailVarificationOTPScreenMobileState
    extends State<EmailVerificationOTPScreenMobile> {
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
        title: const Text("Authentication"),
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
                  fontFamily: "assets/fonts/SmoochSans.ttf"),
            ),*/
            Image.asset(
              "assets/images/otp_avatar.png",
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 10.0),
            Text(
              "Verification",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We have sent you the verification code to - ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "> " + widget.email!,
                  style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  "> " + widget.mobile!,
                  style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
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
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Success"),
                        content: Text('OTP matched'),
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordResetScreen(
                                email: widget.email,
                              )),
                    );
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
                  "Proceed",
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
