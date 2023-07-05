import 'package:blood/screens/homescreen.dart';
import 'package:blood/screens/mapscreen.dart';
import 'package:blood/screens/initialscreen.dart';
import 'package:blood/screens/requestform.dart';
import 'package:blood/screens/requestscreen.dart';
import 'package:blood/screens/welcomesreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/register.dart';
import 'firebase_options.dart';
import 'authentication/phone_signup.dart';
import 'authentication/verify.dart';
import 'screens/my_requests_screen.dart';
import 'screens/landingpage.dart';
Future<void> main() async {
  //TODO Remove delay once app actually takes some time to load
  await Future.delayed(const Duration(seconds: 1, microseconds: 500));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. debug provider
    // 2. safety net provider
    // 3. play integrity provider
    androidProvider: AndroidProvider.debug,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 201, 41, 41),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: user != null ? 'home' : 'initial_screen',
      // initialRoute: 'test_profile',
      debugShowCheckedModeBanner: false,
      routes: {
        'phone_signup': (context) => const MyPhone(),
        'verify': (context) => const MyVerify(),
        'home': (context) => const HomeScreen(),
        'welcome': (context) => const WelcomeScreen(),
        'location_picker': (context) => const NewInter(),
        'personal_info': (context) => const SignUpScreen(),
        'initial_screen': (context) => const InitialScreen(),
        'request': (context) => const BloodRequestList(),
        'reqform':(context) => const RequestForm(),
        'my_requests': (context) => const MyRequestList(),
        'test_profile':(context) => const TestHomeScreen(),
      },
    ),
  );
}

