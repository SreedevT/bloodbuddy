import 'package:blood/Models/userprofile.dart';
import 'package:blood/screens/mapscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood/authentication/signin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  double screenHeight = 0;
  double screenWidth = 0;
  String fname = '';
  String lname = '';
  // DateTime dob
  // DateTime lastDonated
  int age = 0;
  double weight = 0;
  bool isDonor = true;

  FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight / 8,
                ),
                child: Text(
                  "Personal Info...",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: screenWidth / 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            square(-30, 0.12),
            square(-10, 0.3),
            square(10, 1),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight / 2,
                width: screenWidth,
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            onChanged: (val) {
                              fname = val;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your first name';
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            onChanged: (val) {
                              lname = val;
                            },
                            validator: (val) => val!.isEmpty
                                ? "Please enter your last name"
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            onChanged: (val) {
                              age = int.parse(val);
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your age';
                              }
                              if (int.tryParse(val) == null) {
                                return 'Please enter a valid age';
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Age',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          TextFormField(
                            onChanged: (val) {
                              weight = double.parse(val);
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your weight';
                              }
                              if (int.tryParse(val) == null) {
                                return 'Not valid';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Weight',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await DataBase(uid: user!.uid).updateUserProfile(
                                fname,
                                lname,
                                age,
                                weight,
                                isDonor,
                              );
                              print(fname );
                              print(lname );
                              print(age);
                              print(weight );
                              //print(isDonor );
                            }
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => NewInter()),
                              );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red.shade900),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(fontSize: 20),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 49, 11, 8)),
                              ),
                            ),
                          ),
                          child: const Text('Next'),
                        ),
                        const SizedBox(height: 30.0),
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //     bottom: 30,
                        //   ),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.of(context).pushReplacement(
                        //         MaterialPageRoute(
                        //           builder: (context) => const LoginScreen(),
                        //         ),
                        //       );
                        //     },
                        //     child: const Text(
                        //       "Already have an account? Login",
                        //       style: TextStyle(
                        //         fontFamily: "Montserrat",
                        //         color: Colors.black,
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ),
                        //),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget square(double y, double opacity) {
    return Center(
      child: Transform.translate(
        offset: Offset(screenWidth / 30, y),
        child: Transform.rotate(
          angle: -0.4,
          child: Container(
            height: screenHeight / 3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(55),
            ),
          ),
        ),
      ),
    );
  }
}
