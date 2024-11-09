import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../api/api_service.dart';
import '../api/responses/login_response.dart';
import '../models/user.dart';
import '../screens/Dashboard.dart';
import '../services/database.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user; // Using your custom User model (renamed as AppUser)
  AppUser? get user => _user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Updated login method with extlogin flag for manual login
  Future<void> login(String username, String password, String extlogin) async {
    try {
      LoginResponse loginResponse =
          await ApiService.loginApi(username, password, extlogin);

      if (loginResponse.errorCode == 200) {
        _user = AppUser(
          id: loginResponse.id,
          userID: loginResponse.userID,
          username: loginResponse.username,
          name: loginResponse.name,
          email: loginResponse.email,
          mobile: loginResponse.mobile,
          userType: loginResponse.userType,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        notifyListeners();
      } else {
        print(
            "Login failed. ErrorCode: ${loginResponse.errorCode}, Message: ${loginResponse.message}");
      }
    } catch (error) {
      print("Error during login: $error");
    }
  }

  // Google sign-in method
  Future<void> signInWithGoogle(BuildContext context) async {
    // Show loading dialog

    try {
      // Navigator.pop(context);
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = result.user;

      print("firebase user id: ${firebaseUser?.uid}");
      if (firebaseUser != null) {
        // Store user information in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('googleEmail', firebaseUser.email!);
        await prefs.setString('googleName', firebaseUser.displayName ?? "");
        await prefs.setString('extLogin', "Y");

        // Check or create user in your MySQL DB
        await _handleSocialLogin(firebaseUser, "Google");
        notifyListeners();
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-in failed. Please try again.")),
      );
    }
  }

  Future<UserCredential> _signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  /*Future<void> handleSignIn(String type)async{
    try{
      if(type=="apple"){
        var auth = await _signInWithApple();
        if(auth.user!=null){
          String? displayName = auth.user?.displayName;
          String? email = auth.user?.email;
          String? id = auth.user?.uid;
          String? photoURL = auth.user?.photoURL??"";
          UserLogin;
        }
      };
    }
  }*/

  Future<void> signInWithApple(BuildContext context) async {
    // Show loading dialog or loader

    if (Platform.isIOS) {
      try {
        // Apple Sign-In authorization process
        final AuthorizationCredentialAppleID appleCredential =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        // Generate an OAuth credential using the ID token and authorization code
        final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final appleProvider = AppleAuthProvider();
        final AuthCredential credential = oAuthProvider.credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        // Sign in to Firebase with the Apple credential
        /*UserCredential result =
            await FirebaseAuth.instance.signInWithProvider(appleProvider);*/
        UserCredential result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? firebaseUser = result.user;

        print("Firebase user ID: ${firebaseUser?.uid}");

        if (firebaseUser != null) {
          // Check or create user in your MySQL DB
          await _handleSocialLogin(firebaseUser, "Apple");

          // Notify listeners or update UI
          notifyListeners();
        } else {
          // Handle failed login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Sign in with Apple failed. Please try again.")),
          );
        }
      } catch (e) {
        print("Apple sign-in failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Apple Sign-in failed. Please try again.")),
        );
      }
    }
  }

  String generateRandomCode() {
    DateTime now = DateTime.now();
    String dateTimeString =
        '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
    int randomNumber = Random().nextInt(999999); // Random 6-digit number
    String combinedString = dateTimeString + randomNumber.toString();
    return combinedString.substring(combinedString.length - 6);
  }

  // Handle user registration or login in your MySQL DB after social login
  Future<void> _handleSocialLogin(User firebaseUser, String provider) async {
    bool userExists =
        await DatabaseMethods().checkIfUserExists(firebaseUser.uid);

    DateTime now = DateTime.now();
    String dateTimeString = '${now.year}${now.month}${now.day}${now.hour}';
    /*int randomNumber = Random().nextInt(999999); // Random 6-digit number
    String combinedString = dateTimeString + randomNumber.toString();*/
    // print(combinedString);

    if (!userExists) {
      print("user doesnt exists");
      String email = firebaseUser.email ?? "";
      String displayName = firebaseUser.displayName ?? email.split('@')[0];
      Map<String, dynamic> userInfoMap = {
        "email": firebaseUser.email ?? "",
        "name": firebaseUser.displayName ?? displayName,
        "imgUrl": firebaseUser.photoURL ?? "",
        "id": firebaseUser.uid,
        "phone": firebaseUser.phoneNumber ?? "",
      };
      await DatabaseMethods().addUser(firebaseUser.uid, userInfoMap);
      print("Calling createUser API with data:");
      print(
          "UID: ${firebaseUser.uid}, Name: ${firebaseUser.displayName}, Email: ${firebaseUser.email}");

      await ApiService.createUser(
        firebaseUser.uid,
        firebaseUser.displayName ?? displayName + dateTimeString,
        firebaseUser.displayName ?? displayName,
        firebaseUser.email ?? "",
        firebaseUser.phoneNumber ?? "",
        "",
        "S",
        // userType
        "",
        "",
        provider,
      );
    }

    // Fetch user data from your API to set the custom AppUser
    LoginResponse loginResponse =
        await ApiService.loginApi(firebaseUser.uid!, null, "Y");

    print(loginResponse.errorCode);

    if (loginResponse.errorCode == 200) {
      _user = AppUser(
        id: loginResponse.id,
        userID: loginResponse.userID,
        username: loginResponse.username,
        name: loginResponse.name,
        email: loginResponse.email,
        mobile: loginResponse.mobile,
        userType: loginResponse.userType,
      );
      print(_user!.email);
      notifyListeners();
      // return true;
    } else {
      print("Failed to fetch user data");

      notifyListeners();
      // throw Exception("Failed to fetch user data");
      // return false;
    }
  }

  Future<void> autoLoginWithGoogle() async {
    try {
      // Check if the user is currently signed in
      User? firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        // The user is already signed in with Google
        print("Auto-logged in with Google: ${firebaseUser.email}");

        // You might want to fetch user details from your API
        await _handleSocialLogin(firebaseUser, "Google");
        notifyListeners();
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Auto-login with Google failed: $e");
    }
  }

  /*Future<bool> _handleSocialLogin(User firebaseUser, String platform) async {
    try {
      // Check if user exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        // User exists, proceed with login
        final loginResponse =
            await ApiService.loginApi(firebaseUser.email!, null, "Y");
        // Handle successful login response

        print("login response: ${loginResponse.name}");
        if (loginResponse.errorCode == 200) {
          _user = AppUser(
            id: loginResponse.id,
            userID: loginResponse.userID,
            username: loginResponse.username,
            name: loginResponse.name,
            email: loginResponse.email,
            mobile: loginResponse.mobile,
            userType: loginResponse.userType,
          );
          notifyListeners();
          return true;
        } else {
          print("Error during social login");
          throw Exception("Failed to fetch user data");
        }
      } else {
        await _createUserInFirestore(firebaseUser);
        return true;
      }
    } catch (error) {
      print("Error during social login: $error");
      // throw Exception('Failed to handle social login: $error');
      return false;
    }
    // return false; // Login failed
  }*/

  /*Future<void> _createUserInFirestore(User firebaseUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .set({
        'email': firebaseUser.email,
        'name': firebaseUser.displayName,
        'uid': firebaseUser.uid,
        // Add other fields as necessary
      });
    } catch (e) {
      print("Error creating user in Firestore: $e");
      // Handle error if needed
    }
  }*/

  Future<void> logout() async {
    try {
      // Firebase logout
      await _firebaseAuth.signOut();

      // Clear locally stored user data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _user = null; // Clear the custom AppUser
      notifyListeners();
    } catch (error) {
      print('Error during logout: $error');
    }
  }
}

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../api/responses/login_response.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Updated login method with extlogin flag
  Future<void> login(String username, String password, String extlogin) async {
    try {
      // Call the loginApi method from the ApiService with extlogin flag
      LoginResponse loginResponse =
          await ApiService.loginApi(username, password, extlogin);

      // Process the API response
      if (loginResponse.errorCode == 200) {
        _user = User(
          id: loginResponse.id,
          userID: loginResponse.userID,
          username: loginResponse.username,
          name: loginResponse.name,
          email: loginResponse.email,
          mobile: loginResponse.mobile,
          password: loginResponse.password,
          userType: loginResponse.userType,
        );

        // Optionally, store user data using SharedPreferences if needed
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        // Notify listeners to trigger a rebuild in the UI
        notifyListeners();
      } else {
        // Handle unsuccessful login
        print(
            "Login failed. ErrorCode: ${loginResponse.errorCode}, Message: ${loginResponse.message}");
      }
    } catch (error) {
      // Handle errors from the ApiService
      print("Error during login: $error");
    }
  }

  Future<void> logout() async {
    try {
      // Clear stored credentials using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('password');

      // Clear any other session data or tokens

      // Notify listeners that the user has logged out
      _user = null;
      notifyListeners();
    } catch (error) {
      // Handle errors gracefully
      print('Error during logout: $error');
    }
  }
}*/

/*
// providers/auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../api/responses/login_response.dart';


import '../models/user.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> login(String username, String password) async {
    try {
      // Call the loginApi method from the ApiService
      LoginResponse loginResponse =
          await ApiService.loginApi(username, password);

      // Process the API response
      if (loginResponse.errorCode == 200) {
        _user = User(
          id: loginResponse.id,
          userID: loginResponse.userID,
          username: loginResponse.username,
          name: loginResponse.name,
          email: loginResponse.email,
          mobile: loginResponse.mobile,
          password: loginResponse.password,
          userType: loginResponse.userType,
        );

        // Notify listeners to trigger a rebuild in the UI
        notifyListeners();
      } else {
        // Handle unsuccessful login
        print(
            "Login failed. ErrorCode: ${loginResponse.errorCode}, Message: ${loginResponse.message}");
      }
    } catch (error) {
      // Handle errors from the ApiService
      print("Error during login: $error");
    }
  }

  Future<void> logout() async {
    try {
      // Clear stored credentials using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('password');

      // Clear any other session data or tokens

      // Notify listeners that the user has logged out
      _user = null;
      notifyListeners();
    } catch (error) {
      // Handle errors gracefully
      print('Error during logout: $error');
      // You might want to display a message to the user or perform other error handling here
    }
  }
}
*/
