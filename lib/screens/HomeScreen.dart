import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/HomeScreenMobile.dart';
import 'package:risho_speech/screens/tablet/HomeScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: HomeScreenMobile(),
        tabletScaffold: HomeScreenMobile(),
        desktopScaffold: HomeScreenTablet(),
      ),
    );
  }
}
