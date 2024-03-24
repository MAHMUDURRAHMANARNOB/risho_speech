import 'package:flutter/material.dart';

class ProfileScreenTablet extends StatefulWidget {
  const ProfileScreenTablet({super.key});

  @override
  State<ProfileScreenTablet> createState() => _ProfileScreenMobileState();
}

class _ProfileScreenMobileState extends State<ProfileScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return Text("Profile Tablet");
  }
}
