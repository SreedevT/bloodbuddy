import 'package:blood/screens/help.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import '../authentication/authentication.dart';
import '../models/profile.dart';
import '../screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1, microseconds: 500));

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Profile()),
      ],
      child: MaterialApp(
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
        // initialRoute: 'personal_info',
        debugShowCheckedModeBanner: false,
        routes: {
          'phone_signup': (context) => const MyPhone(),
          'verify': (context) => const MyVerify(),
          'home': (context) => const HomeScreen(),
          'welcome': (context) => const WelcomeScreen(),
          'location_picker': (context) => const NewInter(),
          'personal_info': (context) => const SignUpScreen(),
          'initial_screen': (context) => const InitialScreen(),
          'donate': (context) => const RequestPage(),
          //'reqform': (context) => const TestRequestForm(),
          'my_requests': (context) => const MyRequestList(),
          'test_profile': (context) => const TestHomeScreen(),
          'req_form': (context) => const RequestForm(),
          'faq': (context) => const FAQPage(),
          'profile': (context) => const UserProfile(),
          'donate_test': (context) => const TestBloodRequestList(),
          'help_support':(context) => const HelpAndSupport(),
        },
      ),
    ),
  );
}
