import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/LoginScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/LoginScreenMobile.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: LoginScreenMobile(),
        tabletScaffold: LoginScreenTablet(),
        desktopScaffold: LoginScreenTablet(),
      ),
    );
  }
}
