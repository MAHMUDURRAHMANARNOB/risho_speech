import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/ChatScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/ChatScreenMobile.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  ChatScreen({super.key, required this.id});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: ChatScreenMobile(
          id: widget.id,
        ),
        tabletScaffold: ChatScreenTablet(),
        desktopScaffold: ChatScreenTablet(),
      ),
    );
  }
}
