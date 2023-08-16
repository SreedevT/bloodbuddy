import 'dart:developer' as dev;
import 'dart:math';
import 'package:blood/Firestore/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../utils/firebase_api.dart';

class DonorCard extends StatefulWidget {
  const DonorCard({
    super.key,
  });
  @override
  State<DonorCard> createState() => _DonorCardState();
}

class _DonorCardState extends State<DonorCard> {
  late String uid;
  Map<String, dynamic>? data;
  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseApi().initPushNotifications();
    FirebaseApi().initNotification().then((value) => fetchUserProfile());
  }

  fetchUserProfile() async {
    try {
      await DataBase(uid: uid).getUserProfile().then((json) {
        json.addAll({'id': uid});
        Provider.of<Profile>(context, listen: false).setAllFieldsFromJson(json);
        setState(() {
          data = json;
        });
        dev.log("Profile donor_card: $data");
      });
    } catch (e) {
      dev.log("Fetch profile of donor_card: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[800]!,
              Color.fromARGB(255, 158, 25, 25),
              Color.fromARGB(255, 158, 25, 25)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.74, 0.7401, 1],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2)),
      child: Stack(
        children: 
          [
            Image.asset('assets/path2717.png'),
            Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                      child: Text("BB",
                          style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                    )),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/thankshand.png',
                      height: 90,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: const [
                        Text(
                          "\"I do something Amazing",
                          style: TextStyle(
                              letterSpacing: 2,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "I give blood!\"",
                          style: TextStyle(
                              letterSpacing: 2,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                bottomInfoBar()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row bottomInfoBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text(
              'Name',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              '${data?['First Name'] ?? 'loading...'}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              'Blood Group',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              '  ${data?['Blood Group'] ?? 'loading...'}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              'Donor No.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              "${data?['id'].substring(0, 6) ?? 'loading...'}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
