import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:risho_speech/screens/Common/terms_and_condition_widget.dart';
import 'package:risho_speech/screens/Dashboard.dart';
import '../../providers/optProvider.dart';
import '../../ui/colors.dart';
import '../Mobile/OTPScreenMobile.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _obscureText = true;
  bool _isReadOnly = true;

  bool isCheckboxChecked = true;

  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // Initially hide the password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleReadOnly() {
    setState(() {
      _isReadOnly = !_isReadOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context);

    void generateUsername(String fullName) {
      if (fullName.isNotEmpty) {
        // Split the full name into parts
        List<String> nameParts = fullName.trim().split(' ');

        // Take the first part of the full name
        String firstName = nameParts.isNotEmpty ? nameParts[0] : '';

        // Generate random digits
        String randomDigits = Random().nextInt(10000).toString();

        // Build username by appending random digits to the first part of the name
        String username = firstName + randomDigits;

        // Update the username field
        setState(() {
          userNameController.text = username;
          print(username);
        });
      } else {
        // Clear the username field if the full name is empty
        setState(() {
          userNameController.text = '';
        });
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Smooch',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Lets get Started",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 10),
          /*FULLNAME INPUT BOX*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FullName",
              ),
              TextField(
                controller: fullNameController,
                keyboardType: TextInputType.text,
                cursorColor: AppColors.primaryColor,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                onChanged: (value) {
                  setState(() {
                    generateUsername(value);
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Your Full Name',
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
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
              ),
            ],
          ),

          const SizedBox(height: 10),
          /*USERNAME INPUT BOX*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "UserName",
              ),
              TextField(
                controller: userNameController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppColors.primaryColor,
                readOnly: _isReadOnly,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.verified_user_outlined,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isReadOnly ? Icons.edit : Icons.edit_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: _toggleReadOnly,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Generated Username',
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
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
              ),
            ],
          ),

          const SizedBox(height: 10),
          /*EMAIL INPUT BOX*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppColors.primaryColor,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Your Email',
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
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
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "OTP will be sent here",
                    style: TextStyle(color: AppColors.secondaryColor),
                  ),
                ],
              )
            ],
          ),
          // const SizedBox(height: 10), // Add vertical space
          /*Phone INPUT BOX*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Phone No",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextField(
                controller: mobileController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9\+]{0,11}$')),
                ],
                keyboardType: TextInputType.phone,
                cursorColor: AppColors.primaryColor,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.call_outlined,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Your Phone No',
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Border radius
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
                  fillColor: Colors.grey[200], // Background color
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
          const SizedBox(height: 10),
          Container(
            child: Row(
              children: [
                Checkbox(
                  activeColor: AppColors.primaryColor,
                  value: isCheckboxChecked,
                  onChanged: (value) {
                    // This is where we update the state when the checkbox is tapped
                    setState(() {
                      isCheckboxChecked = value!;
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      /*_showTermsAndConditionsDialog(context);*/
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => TermsAndConditionsDialog(),
                      );
                    },
                    child: Text(
                      "By checking this, you will agree to our terms and conditions",
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Add vertical space
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primaryColor, // Change the background color
            ),
            onPressed: isCheckboxChecked
                ? () async {
                    // Show loading dialog
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
                              contentPadding: EdgeInsets.all(10.0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                      "assets/images/risho_guru_icon.png"),
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
                    String password = passwordController.text.trim();
                    String fullName = fullNameController.text.trim();
                    String userName = userNameController.text.trim();
                    // Check if OTP retrieval was successful
                    if (emailAddress.isNotEmpty &&
                        mobileNo.isNotEmpty &&
                        password.isNotEmpty &&
                        fullName.isNotEmpty &&
                        userName.isNotEmpty) {
                      // Call getOtp with the retrieved email
                      await otpProvider.fetchOtp(emailAddress);

                      print("OTP IS: ${otpProvider.otpResponseModel!.otp}");

                      // Continue with the existing logic for navigating to OTP screen
                      if (otpProvider.otpResponseModel != null &&
                          otpProvider.otpResponseModel!.otp != null) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreenMobile(
                              otp: otpProvider.otpResponseModel?.otp ?? 0,
                              userName: userName.toString(),
                              fullName: fullName.toString(),
                              email: emailAddress.toString(),
                              mobile: mobileNo.toString(),
                              password: password.toString(),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(otpProvider.otpResponseModel!.message),
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(context); // Close the loading dialog
                      // Show an error message if email is empty
                      if (emailController.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter your email.'),
                          ),
                        );
                      } else if (mobileController.text.length < 11) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter valid Phone No.'),
                          ),
                        );
                      } else if (passwordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter 6 digit Password.'),
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
                  }
                : null,
            child: Container(
              width: 350,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 5), // Add vertical space
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                'Signup',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
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
          /*const SizedBox(height: 20),*/ // Add vertical space
          /*Signup with google*/
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.google, // Google icon from Font Awesome
                      color: Colors.red, // Change the color of the Google logo
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons
                          .facebookF, // Google icon from Font Awesome
                      color: Colors.blue, // Change the color of the Google logo
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*const SizedBox(height: 20),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an Account? ',
                style: TextStyle(fontSize: 14.0),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor.withOpacity(0.1),
                ),
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );*/
                  // Navigate back when the button is pressed
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: AppColors.secondaryColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TermsAndConditionsDialog(); // Call TermsAndConditionsDialog to display the dialog
      },
    );
  }
}
