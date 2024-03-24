import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/LearnScreenMobile.dart';
import 'package:risho_speech/screens/tablet/LearnScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: LearnScreenMobile(),
        tabletScaffold: LearnScreenTablet(),
        desktopScaffold: LearnScreenTablet(),
      ),
    );
  }
}
