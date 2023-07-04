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
  late final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450.0,
      height: 160.0,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(40, 44, 52, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Welcome',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text('Name',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 254, 254),
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
              const SizedBox(width: 150),
              Image.asset(
                'assets/images/blood.png',
                scale: 1,
                height: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Row(
              children: [
                const Text(
                  'User id',
                  style: TextStyle(
                      color: Color.fromARGB(255, 170, 168, 168), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
