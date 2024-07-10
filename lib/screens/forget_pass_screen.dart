import 'package:flutter/material.dart';
import '../responsive/responsive_layout.dart';
import 'Mobile/forgetPassScreenMobile.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: const ForgetPassScreenMobile(),
        tabletScaffold: const ForgetPassScreenMobile(),
        desktopScaffold: const ForgetPassScreenMobile(),
      ),
    );
  }
}
