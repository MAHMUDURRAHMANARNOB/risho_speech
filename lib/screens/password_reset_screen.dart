import 'package:flutter/material.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/passwordResetScreenMobile.dart';

class PasswordResetScreen extends StatefulWidget {
  final String? email;

  PasswordResetScreen({this.email, super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: PasswordResetScreenMobile(email: widget.email),
        tabletScaffold: PasswordResetScreenMobile(email: widget.email),
        desktopScaffold: PasswordResetScreenMobile(email: widget.email),
      ),
    );
  }
}
