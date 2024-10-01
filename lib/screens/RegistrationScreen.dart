import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/RegistrationScreenMobile.dart';
import 'package:risho_speech/screens/tablet/RegistrationScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: RegistrationScreenMobile(),
        tabletScaffold: RegistrationScreenMobile(),
        desktopScaffold: RegistrationScreenMobile(),
      ),
    );
  }
}
