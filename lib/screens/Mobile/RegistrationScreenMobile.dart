import 'package:flutter/material.dart';

import '../../ui/colors.dart';
import '../Common/registration_form.dart';

class RegistrationScreenMobile extends StatefulWidget {
  const RegistrationScreenMobile({super.key});

  @override
  State<RegistrationScreenMobile> createState() =>
      _RegistrationScreenMobileState();
}

class _RegistrationScreenMobileState extends State<RegistrationScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorDark,
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: RegistrationForm(),
            ),
          ),
        ],
      ),
    );
  }
}
