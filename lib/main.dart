import 'dart:math';
import 'package:blood/screens/homescreen.dart';
import 'package:blood/screens/mapscreen.dart';
import 'package:blood/screens/welcomesreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:blood/authentication/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'authentication/phone_signup.dart';
import 'authentication/verify.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. debug provider
    // 2. safety net provider
    // 3. play integrity provider
    androidProvider: AndroidProvider.debug,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;  // establishes an active session
  User? user = auth.currentUser;      // get the curret user info which is locally cached
  runApp(MaterialApp(
    initialRoute: user != null ? 'register_test' : 'welcome',
    debugShowCheckedModeBanner: false,
    routes: {
      'phone_signup': (context) => MyPhone(),
      'verify': (context) => MyVerify(),
      'register_test': (context) => SignUpScreen(),
      'home':(context) => HomeScreen(),
      'welcome':(context) => WelcomeScreen(),
      'map':(context) => NewInter(),
    },
  ));
}
