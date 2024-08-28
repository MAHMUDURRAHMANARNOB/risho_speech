import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';

import '../../providers/optProvider.dart';
import '../../ui/colors.dart';
import '../emailVerificationOTPScreen.dart';

class ForgetPassScreenMobile extends StatefulWidget {
  const ForgetPassScreenMobile({super.key});

  @override
  State<ForgetPassScreenMobile> createState() => _ForgetPassScreenMobileState();
}

class _ForgetPassScreenMobileState extends State<ForgetPassScreenMobile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Password Recovery",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: AppColors.primaryColor,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Iconsax.direct,
                  color: Colors.grey[900], // Change the color of the icon
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                hintText: 'Your Valid Email',
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
            const SizedBox(height: 20),
            Text(
              "MobileNo",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.primaryColor,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Iconsax.call,
                  color: Colors.grey[900], // Change the color of the icon
                ),
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                hintText: 'Your Valid Mobile Number',
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
                backgroundColor:
                    AppColors.primaryColor, // Change the background color
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
                              Image.asset(
                                "assets/images/risho_guru_icon.png",
                                height: 100,
                              ),
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
                // Retrieve OTP when the button is pressed
                String emailAddress = emailController.text.trim();
                String mobileNo = mobileController.text.trim();
                if (emailAddress.isNotEmpty && mobileNo.isNotEmpty) {
                  // Call getOtp with the retrieved email
                  await otpProvider.fetchOtp(emailAddress, mobileNo);

                  print("OTP IS: ${otpProvider.otpResponseModel!.otp}");

                  // Continue with the existing logic for navigating to OTP screen
                  if (otpProvider.otpResponseModel != null &&
                      otpProvider.otpResponseModel!.otp != null) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailVerificationOTPScreen(
                          otp: otpProvider.otpResponseModel?.otp ?? 0,
                          email: emailAddress.toString(),
                          mobile: mobileNo.toString(),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(otpProvider.otpResponseModel!.message),
                      ),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  if (emailController.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter your email.'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter Valid information.'),
                      ),
                    );
                  }
                }
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailVerificationOTPScreen(
                      otp: 1234,
                      email: 'test@gmail.com',
                    ),
                  ),
                );*/
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: const Text(
                  'Send OTP',
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
