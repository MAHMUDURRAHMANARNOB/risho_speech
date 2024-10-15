import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/LanguageHomeScreenMobile.dart';

class LanguageHomeScreen extends StatefulWidget {
  const LanguageHomeScreen({super.key});

  @override
  State<LanguageHomeScreen> createState() => _LanguageHomeScreenState();
}

class _LanguageHomeScreenState extends State<LanguageHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: LanguageHomeScreenMobile(),
        tabletScaffold: LanguageHomeScreenMobile(),
        desktopScaffold: LanguageHomeScreenMobile(),
      ),
    );
  }
}
