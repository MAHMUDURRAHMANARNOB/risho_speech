import 'package:flutter/material.dart';
import '../responsive/responsive_layout.dart';
import 'Mobile/emailVerificationOTPScreenMobile.dart';

class EmailVerificationOTPScreen extends StatefulWidget {
  final int? otp;
  final String? email;

  const EmailVerificationOTPScreen({this.otp, this.email, super.key});

  @override
  State<EmailVerificationOTPScreen> createState() =>
      _EmailVerificationOTPScreenState();
}

class _EmailVerificationOTPScreenState
    extends State<EmailVerificationOTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: EmailVerificationOTPScreenMobile(
          otp: widget.otp,
          email: widget.email,
        ),
        tabletScaffold: EmailVerificationOTPScreenMobile(
          otp: widget.otp,
          email: widget.email,
        ),
        desktopScaffold: EmailVerificationOTPScreenMobile(
          otp: widget.otp,
          email: widget.email,
        ),
      ),
    );
  }
}
