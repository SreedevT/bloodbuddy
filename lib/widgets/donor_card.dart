import 'dart:developer';
import 'package:blood/Firestore/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    fetchUserProfile();
  }

  fetchUserProfile() async {
    try {
      Map<String, dynamic> fetchedData =
          await DataBase(uid: uid).getUserProfile();
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450.0,
      height: 220.0,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
      decoration: BoxDecoration(
          color: Colors.red[800], borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2)
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Stack(
              children: [
                Container(
                  height: 30,
                  width: 35,
                  color: Colors.white,
                ),
                Text(" BB",
                    style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          Row(
            children: [
              Image.asset('assets/images/thankshand.png', height: 90),
              const SizedBox(width: 10),
              const Text(
                "\"I do something Amazing\n\t\t\t\tI give blood !\"",
                style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Name',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                'Blood Group',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                'Donor No',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data?['First Name'] ?? 'loading...'}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '  ${data?['Blood Group'] ?? 'loading...'}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                '0A3E4r',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }
}
