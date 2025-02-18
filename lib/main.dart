import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:provider/provider.dart';
import 'package:risho_speech/providers/IeltsCourseListProvider.dart';
import 'package:risho_speech/providers/IeltsCourseVideoAnsProvider.dart';
import 'package:risho_speech/providers/IeltsVocabularyCategoryListProvider.dart';
import 'package:risho_speech/providers/IeltsVocabularyListProvider.dart';
import 'package:risho_speech/providers/LanguageTutorResponseProvider.dart';
import 'package:risho_speech/providers/ShonodAiResponseProvider.dart';
import 'package:risho_speech/providers/TutorResponseProvider.dart';
import 'package:risho_speech/providers/TutorSpokenCourseProvider.dart';
import 'package:risho_speech/providers/VocabularyDialogListProvider.dart';
import 'package:risho_speech/providers/VocabularySentenceListProvider.dart';
import 'package:risho_speech/providers/auth_provider.dart';
import 'package:risho_speech/providers/callAndConversationProvider.dart';
import 'package:risho_speech/providers/calling_agentProvider.dart';
import 'package:risho_speech/providers/coupnDiscountProvider.dart';
import 'package:risho_speech/providers/createUserProvider.dart';
import 'package:risho_speech/providers/deleteUserProvider.dart';
import 'package:risho_speech/providers/doConversationProvider.dart';
import 'package:risho_speech/providers/doGuidedConversationProvider.dart';
import 'package:risho_speech/providers/endIeltsListeningExamPrivider.dart';
import 'package:risho_speech/providers/ieltsCourseLessonListProvider.dart';
import 'package:risho_speech/providers/ieltsListeningExamQuestionProvider.dart';
import 'package:risho_speech/providers/languageListProvider.dart';
import 'package:risho_speech/providers/nextQuestionProvider.dart';
import 'package:risho_speech/providers/optProvider.dart';
import 'package:risho_speech/providers/packagesProvider.dart';
import 'package:risho_speech/providers/resetPasswordProvider.dart';
import 'package:risho_speech/providers/speakingExamProvider.dart';
import 'package:risho_speech/providers/spokenLessonListProvider.dart';
import 'package:risho_speech/providers/subscriptionStatus_provider.dart';
import 'package:risho_speech/providers/suggestAnswerProvider.dart';
import 'package:risho_speech/providers/validateSpokenSentenceProvider.dart';
import 'package:risho_speech/providers/vocabularyCategoryListProvider.dart';
import 'package:risho_speech/providers/vocabularyPracticeListProvider.dart';
import 'package:risho_speech/providers/vocabularyPronunciationProvider.dart';
import 'package:risho_speech/screens/LoginScreen.dart';
import 'package:risho_speech/screens/RegistrationScreen.dart';
import 'package:risho_speech/screens/SplashScreen.dart';
import 'package:risho_speech/screens/WelcomeScreen.dart';
import 'package:risho_speech/utils/theme/theme.dart';
import 'package:shurjopay/utilities/functions.dart';
import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';

// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FlutterInappPurchase.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeShurjopay(environment: "live");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => OtpProvider()),
        ChangeNotifierProvider(create: (context) => UserCreationProvider()),
        ChangeNotifierProvider(create: (context) => DoConversationProvider()),
        ChangeNotifierProvider(
            create: (context) => DoGuidedConversationProvider()),
        ChangeNotifierProvider(create: (context) => ValidateSentenceProvider()),
        ChangeNotifierProvider(create: (context) => SpokenLessonListProvider()),
        ChangeNotifierProvider(create: (context) => NextQuestionProvider()),
        ChangeNotifierProvider(create: (context) => SuggestAnswerProvider()),
        ChangeNotifierProvider(create: (context) => CallingAgentListProvider()),
        ChangeNotifierProvider(create: (context) => CallConversationProvider()),
        ChangeNotifierProvider(
            create: (context) => VocabularyCategoryListProvider()),
        ChangeNotifierProvider(
            create: (context) => VocabularyPracticeProvider()),
        ChangeNotifierProvider(
            create: (context) => VocabularyDialogListProvider()),
        ChangeNotifierProvider(
            create: (context) => VocabularySentenceListProvider()),
        ChangeNotifierProvider(
            create: (context) => ValidatePronunciationProvider()),
        ChangeNotifierProvider(create: (context) => PackagesProvider()),
        ChangeNotifierProvider(
            create: (context) => SubscriptionStatusProvider()),
        ChangeNotifierProvider(create: (context) => CouponDiscountProvider()),
        ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (context) => IeltsListeningProvider()),
        ChangeNotifierProvider(create: (context) => IeltsCourseListProvider()),
        ChangeNotifierProvider(
            create: (context) => IeltsVocabularyCategoryListProvider()),
        ChangeNotifierProvider(create: (context) => IeltsLessonReplyProvider()),
        ChangeNotifierProvider(
            create: (context) => IeltsVocabularyListProvider()),
        ChangeNotifierProvider(
            create: (context) => IeltsCourseLessonListProvider()),
        ChangeNotifierProvider(
            create: (context) => IeltsSpeakingExamProvider()),
        ChangeNotifierProvider(
            create: (context) => EndIeltsListeningProvider()),
        ChangeNotifierProvider(create: (context) => ShonodAiResponseProvider()),
        ChangeNotifierProvider(create: (context) => TutorResponseProvider()),
        ChangeNotifierProvider(
            create: (context) => TutorSpokenCourseProvider()),
        ChangeNotifierProvider(create: (context) => LanguageListProvider()),
        ChangeNotifierProvider(
            create: (context) => LanguageTutorResponseProvider()),
        ChangeNotifierProvider(create: (context) => DeleteUserProvider()),
      ],
      child: UpgradeAlert(
        child: RishoSpeech(),
      ),
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

    /*return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
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
        });*/
  }
}
