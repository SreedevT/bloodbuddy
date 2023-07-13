import 'dart:developer';
import 'package:blood/authentication/phone_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  static String verificationId = "";
  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _codeSent = false;
  bool _wrongCode = false;

  final TextEditingController pinController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 110, 110, 110)),
      borderRadius: BorderRadius.circular(20),
      color: Colors.grey.shade50,
    ),
  );
  late final PinTheme focusedPinTheme;
  late final PinTheme errorPinTheme;

  Future verify() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: MyPhone.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        log("Auto verification: ${credential.toString()}");
        pinController.setText(credential.smsCode!);
        await _auth.signInWithCredential(credential);
        log('Verification Complete!!!!!!!!!!!');
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Verification Failed ${e.toString()}");
      },
      codeSent: (String verificationId, int? resendToken) {
        MyVerify.verificationId = verificationId;
        setState(() {
          _codeSent = true;
        });
        log("Code Sent: $verificationId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log("Timeout ${verificationId.toString()}");
      },
    );
  }

  @override
  void initState() {
    verify();
    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    );
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
  }

  Future<bool> isUserDocumentExists() async {
    String? uid = user!.uid;
    DocumentSnapshot userSnapShot = await FirebaseFirestore.instance
        .collection('User Profile')
        .doc(uid)
        .get();
    return userSnapShot.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[800],
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //? Show different image based on codeSent callback of verify()
            _codeSent
                ? Image.asset(
                    'assets/verify.png',
                    width: 150,
                    height: 150,
                  )
                : Lottie.asset(
                    'assets/lottie/otpverification.json',
                    width: 150,
                    height: 150,
                  ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Enter the OTP sent to ${MyPhone.phoneNumber}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "We need to register your phone to get started!",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Pinput(
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              errorPinTheme: errorPinTheme,
              enabled: _codeSent,
              forceErrorState: _wrongCode,
              length: 6,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
              controller: pinController,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => log(pin),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: MyVerify.verificationId,
                            smsCode: pinController.text);

                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential);

                    // ignore: unrelated_type_equality_checks
                    bool isExist = await isUserDocumentExists();
                    if (isExist) {
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'home',
                        (route) => false,
                      );
                    } else {
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'personal_info',
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    setState(() {
                      _wrongCode = true;
                    });
                    log("Verify Error: ${e.toString()}, $_wrongCode");
                  }
                },
                child: const Text(
                  "Verify Phone Number",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      // Check if widget is mounted before using context
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'phone_signup',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Edit Phone Number ?",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
