import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/IELTSHomeScreenMobile.dart';
import 'package:risho_speech/screens/tablet/IELTSHomeScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class IELTSHomeScreen extends StatefulWidget {
  const IELTSHomeScreen({super.key});

  @override
  State<IELTSHomeScreen> createState() => _IELTSHomeScreenState();
}

class _IELTSHomeScreenState extends State<IELTSHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IELTSHomeScreenMobile(),
        tabletScaffold: IELTSHomeScreenMobile(),
        desktopScaffold: IELTSHomeScreenTablet(),
      ),
    );
  }
}
