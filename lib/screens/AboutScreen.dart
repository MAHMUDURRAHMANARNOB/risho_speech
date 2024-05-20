import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/AboutScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/AboutScreenMobile.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: AboutScreenMobile(),
        tabletScaffold: AboutScreenTablet(),
        desktopScaffold: AboutScreenTablet(),
      ),
    );
  }
}
