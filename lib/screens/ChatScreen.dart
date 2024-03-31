import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/ChatScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/ChatScreenMobile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: ChatScreenMobile(),
        tabletScaffold: ChatScreenTablet(),
        desktopScaffold: ChatScreenTablet(),
      ),
    );
  }
}
