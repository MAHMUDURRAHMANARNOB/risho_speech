import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:risho_speech/screens/authDataPage.dart';
import 'package:risho_speech/services/database.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/scope.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseauth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential result = await firebaseauth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email ?? "",
        "name": userDetails!.displayName ?? "",
        "imgUrl": userDetails!.photoURL ?? "",
        "id": userDetails.uid ?? "",
        "phone": userDetails.phoneNumber ?? "",
      };
      await DatabaseMethods()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthDataPage(),
          ),
        );
      });
    }
  }

  Future<User?> signInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential = result.credential!;
        final oAuthCredential = OAuthProvider("apple.com");
        final credential = oAuthCredential.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
        final UserCredential = await auth.signInWithCredential(credential);
        final firebaseUser = UserCredential.user;
        if (scopes.contains(Scope.fullName)) {
          final fullName = AppleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser!.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
            code: "ERROR_AUTHORIZATION_DENIED",
            message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: "ERROR_ABORTED_BY_USER", message: "Sign in aborted by user");
      default:
        throw UnimplementedError();
    }
  }
}
