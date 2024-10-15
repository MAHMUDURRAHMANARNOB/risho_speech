import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:risho_speech/models/LanguageTutorResponseDataModel.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/LanguageTutorScreenMobile.dart';

class LanguageTutorScreen extends StatefulWidget {
  final LanguageTutorSuccessResponse tutorResponse;
  final String languageName;

  const LanguageTutorScreen(
      {super.key, required this.tutorResponse, required this.languageName});

  @override
  State<LanguageTutorScreen> createState() => _LanguageTutorScreenState();
}

class _LanguageTutorScreenState extends State<LanguageTutorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: LanguageTutorScreenMobile(
            tutorResponse: widget.tutorResponse,
            languageName: widget.languageName),
        tabletScaffold: LanguageTutorScreenMobile(
            tutorResponse: widget.tutorResponse,
            languageName: widget.languageName),
        desktopScaffold: LanguageTutorScreenMobile(
            tutorResponse: widget.tutorResponse,
            languageName: widget.languageName),
      ),
    );
  }
}
