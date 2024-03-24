import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/ProfileScreenMobile.dart';
import 'package:risho_speech/screens/tablet/ProfileScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: ProfileScreenMobile(),
        tabletScaffold: ProfileScreenTablet(),
        desktopScaffold: ProfileScreenTablet(),
      ),
    );
  }
}
