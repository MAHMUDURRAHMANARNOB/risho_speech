import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/auth_provider.dart';
import 'package:risho_speech/providers/doConversationProvider.dart';
import 'package:risho_speech/providers/spokenLessonListProvider.dart';
import 'package:risho_speech/providers/validateSpokenSentenceProvider.dart';
import 'package:risho_speech/screens/LoginScreen.dart';
import 'package:risho_speech/screens/RegistrationScreen.dart';
import 'package:risho_speech/screens/SplashScreen.dart';
import 'package:risho_speech/screens/WelcomeScreen.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DoConversationProvider()),
        ChangeNotifierProvider(create: (context) => ValidateSentenceProvider()),
        ChangeNotifierProvider(create: (context) => SpokenLessonListProvider()),
      ],
      child: RishoSpeech(),
    ),
  );
}

class RishoSpeech extends StatelessWidget {
  const RishoSpeech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodySmall: TextStyle(
              fontFamily: 'Poppins', // Set the custom font as the default
              fontSize: 12,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Poppins', // Set the custom font as the default
              fontSize: 14,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Poppins', // Set the custom font as the default
              fontSize: 18,
            ),
            // You can define more text styles here as needed
          ),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          // OtpScreenMobile.id: (context) => OtpScreenMobile(),
          // Dashboard.id: (context) => Dashboard(),
          // CoursesScreen.id: (context) => CoursesScreen(),
          // StudySectionScreen.id: (context) => StudySectionScreen(),
          // PackagesScreen.id: (context) => PackagesScreen(),
          // ToolsScreen.id: (context) => ToolsScreen(),
          // DashboardScreen.id: (context) => DashboardScreen(),
        });
  }
}
