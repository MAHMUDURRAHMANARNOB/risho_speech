import 'package:flutter/material.dart';

import '../../ui/colors.dart';
import '../Common/registration_form.dart';

class RegistrationScreenTablet extends StatefulWidget {
  const RegistrationScreenTablet({super.key});

  @override
  State<RegistrationScreenTablet> createState() =>
      _RegistrationScreenTabletState();
}

class _RegistrationScreenTabletState extends State<RegistrationScreenTablet> {
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
