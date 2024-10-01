import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IELTSHomeScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsCourseScreenMobile.dart';

class IeltsCourseScreen extends StatefulWidget {
  const IeltsCourseScreen({super.key});

  @override
  State<IeltsCourseScreen> createState() => _IELTSHoneScreenState();
}

class _IELTSHoneScreenState extends State<IeltsCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsCourseScreenMobile(),
        tabletScaffold: IeltsCourseScreenMobile(),
        desktopScaffold: IeltsCourseScreenMobile(),
      ),
    );
  }
}
