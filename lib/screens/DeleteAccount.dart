import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/DeleteAccountScreenMobile.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: DeleteAccountScreenMobile(),
        tabletScaffold: DeleteAccountScreenMobile(),
        desktopScaffold: DeleteAccountScreenMobile(),
      ),
    );
  }
}
