import 'package:flutter/material.dart';
import 'package:risho_speech/ui/colors.dart';

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  State<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorDark,
      body: Column(
        children: [
          Image.asset(
            "assets/images/risho_speech.png",
            width: 200,
            height: 100,
            alignment: Alignment.center,
          ),
          Text(
            "Login to Risho-Speech",
          )
        ],
      ),
    );
  }
}
