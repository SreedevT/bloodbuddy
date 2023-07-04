import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import '../Firestore/userprofile.dart';

class TestHomeScreen extends StatefulWidget {
  const TestHomeScreen({super.key});

  @override
  State<TestHomeScreen> createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // variables to retrieve user profile data from firestore
  User? user;
  // String? fname;
  // String? lname;
  // DateTime? dob;
  // dynamic lastDonated;
  // int? age;
  // double? weight;
  // String? bloodGroup;
  // bool? isDonor;
  // bool? q1;
  // bool? q2;
  // bool? q3;
  Map<String, dynamic>? data;

  @override
  void initState() {
    user = _auth.currentUser;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    super.initState();
    fetchUserProfile();
  }

// function to fetch user profile data from firestore

  fetchUserProfile() async {
    try {
      Map<String, dynamic> fetchedData =
          await DataBase(uid: user!.uid).getUserProfile();
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Personal Info",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("First Name: ${data?['First Name'] ?? 'loading...'}"),
            Text("Last Name: ${data?['Last Name'] ?? 'loading...'}"),
            Text("Age: ${data?['Age'] ?? 'loading...'}"),
            Text("Weight: ${data?['Weight'] ?? 'loading...'}"),
            Text("Blood Group: ${data?['Blood Group'] ?? 'loading...'}"),
            Text("Is donor: ${data?['Is donor'] ?? 'loading...'}"),
            Text("Last Donated: ${data?['Last Donated'] ?? 'Not available'}"),
            Text("tattoo: ${data?['tattoo'] ?? 'loading...'}"),
            Text("HIV_tested: ${data?['HIV_tested'] ?? 'loading...'}"),
            Text("Covid_vaccine: ${data?['Covid_vaccine'] ?? 'loading...'}"),

            const SizedBox(
              height: 50,
            ),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.signOut();
                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'welcome',
                    (route) => false,
                  );
                } catch (e) {
                  log(e.toString());
                }
              },
              child: const Text("Log out"),
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                ),
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.pushNamed(
                    context,
                    'reqform',
                  );
                },
                child: const Text("Requests page",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                ),
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.pushNamed(
                    context,
                    'request',
                  );
                },
                child: const Text("Donate",
                    style: TextStyle(color: Colors.white)),
              ),
            const SizedBox(
              height: 20,
            ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                ),
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.pushNamed(
                    context,
                    'my_requests',
                  );
                },
                child: const Text("My Requests",
                    style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
