import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // variables to retrieve user profile data from firestore
  User? user;
  String? fname;
  String? lname;
  DateTime? dob;
  dynamic lastDonated;
  int? age;
  double? weight;
  String? bloodGroup;
  bool? isDonor;
  bool? q1;
  bool? q2;
  bool? q3;

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
    final CollectionReference userProfile =
        FirebaseFirestore.instance.collection('User Profile');
    try {
      await userProfile.doc(user!.uid).get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            fname = data['First Name'];
            lname = data['Last Name'];
            dob = data['Date of Birth'].toDate();
            age = data['Age'];
            weight = data['Weight'];
            bloodGroup = data['Blood Group'];
            isDonor = data['Is donor'];
            lastDonated = data['Last Donated'];
            q1 = data['tattoo'];
            q2 = data['HIV_tested'];
            q3 = data['Covid_vaccine'];
            // print(fname);
          });
        }
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
            Text("First Name: $fname"),
            Text("Last Name: $lname"),
            Text("Date of Birth: $dob"),
            Text("Age: $age"),
            Text("Weight: $weight"),
            Text("Blood Group: $bloodGroup"),
            Text("Is donor: $isDonor"),
            Text("Last Donated: $lastDonated"),
            Text("tattoo: $q1"),
            Text("HIV_tested: $q2"),
            Text("Covid_vaccine: $q3"),
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
                    'request',
                  );
                },
                child: const Text("Requests page",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
