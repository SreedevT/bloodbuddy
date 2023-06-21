import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'phone_signup.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  static String verificationId = "";
  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String code = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  // late BuildContext con;  // to capture the context

  @override
  void initState() {
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
    // con = context;  // to capture the updated context
    // //this con is used inside the onpressed which is async function
    // // since after the completetion of the async function, it will get the updated context
    // //this removes any potential error

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[900],
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/img1.png',
              //   width: 150,
              //   height: 150,
              // ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
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
                        backgroundColor: Colors.red[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: MyVerify.verificationId,
                                smsCode: code);

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
                        log("Verify Error: ${e.toString()}");
                      }
                    },
                    child: const Text("Verify Phone Number")),
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
      ),
    );
  }
}
