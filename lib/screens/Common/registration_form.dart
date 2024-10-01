import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:risho_speech/screens/Common/terms_and_condition_widget.dart';
import 'package:risho_speech/screens/Dashboard.dart';
import '../../providers/createUserProvider.dart';
import '../../providers/optProvider.dart';
import '../../ui/colors.dart';
import '../Mobile/OTPScreenMobile.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
          // print(username);
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
                    Iconsax.user,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Your Full Name',
                  filled: true,
                  fillColor: Colors.grey[200],
                  // Background color
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
                    Iconsax.verify,
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
                  fillColor: Colors.grey[200],
                  // Background color
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
                    Iconsax.direct,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Your Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                  // Background color
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
          const SizedBox(height: 10), // Add vertical space
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
                    Iconsax.call,
                    color: Colors.grey[900], // Change the color of the icon
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: 'Your Phone No',
                  filled: true,
                  fillColor: Colors.grey[200],
                  // Background color
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                "OTP will be sent to your Phone and Email",
                style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          // const SizedBox(height: 10), // Add vertical space
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
                    Iconsax.lock,
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
                      child: RichText(
                        text: TextSpan(
                          text: 'By checking this, you will agree to our ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'terms and conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryColor),
                            ),
                            // TextSpan(text: ' world!'),
                          ],
                        ),
                      )
                      /*Text(
                      "By checking this, you will agree to our terms and conditions",
                      softWrap: true,
                    ),*/
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
                                    "assets/images/risho_guru_icon.png",
                                    width: 80,
                                    height: 80,
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
                      await otpProvider.fetchOtp(emailAddress, mobileNo);

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
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20), // Add vertical space

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
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
              label: Text(
                'Sign up with Apple',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                try {
                  final credential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );
                  String authorizationCode = credential.authorizationCode;
                  String? email = credential.email; // Optional if provided
                  String? fullName = credential.givenName! +
                      ' ' +
                      credential.familyName!; // Optional if provided

                  // Now, handle user creation with the Apple Sign-In information
                  handleAppleSignIn(
                      context, authorizationCode, email, fullName);
                  // Process the credential
                } catch (e) {
                  print('Apple Sign-In error: $e');
                }
                /*final credential = await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                );*/

                // Send the authorization code to your backend for validation
                // Use credential.authorizationCode
                // Extract credentials
              },
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.apple,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),

          /*Signup with google*/
          const SizedBox(height: 30),

          /*const SizedBox(height: 20),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an Account? ',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
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
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void handleAppleSignIn(BuildContext context, String authorizationCode,
      String? email, String? fullName) async {
    // Call your backend or Provider method to create a user using the authorization code.
    final response =
        await Provider.of<UserCreationProvider>(context, listen: false)
            .createUser(
      "apple_user_${DateTime.now().millisecondsSinceEpoch}",
      // You can use a unique ID, such as a timestamp
      email ?? "unknown@apple.com",
      // If Apple does not provide email, use a fallback
      fullName ?? "Unknown User",
      // If Apple does not provide a name, use a fallback
      email ?? "unknown@apple.com",
      "not-provided",
      // No mobile number provided by Apple
      "123456",
      // Set a default password for Apple Sign-In users, or leave blank
      "S",
      "not-mentioned",
      "not-mentioned",
      "not-mentioned",
    );

    if (response == true) {
      // Handle successful user creation and login as shown in your code
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        (route) => false,
      );
    } else if (response == false) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text('User already exists or other issue occurred.'),
        ),
      );
    } else {
      // Handle unexpected response
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text('Unexpected response format.'),
        ),
      );
    }
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
