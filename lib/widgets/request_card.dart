import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BloodRequestCard extends StatefulWidget {
  final String id;
  final String hospital;
  final int units;
  final String bloodGroup;
  final String name;


  //TODO in the final version, this card must take in a request object
  const BloodRequestCard({
    Key? key,
    required this.id,
    required this.hospital,
    required this.units,
    required this.bloodGroup,
    required this.name,
  }) : super(key: key);

  @override
  State<BloodRequestCard> createState() => _BloodRequestCardState();
}

class _BloodRequestCardState extends State<BloodRequestCard> {
  bool _visible = false;
  bool _interested = false;
  late String user;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!.uid;
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
    isInterestShown();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void isInterestShown() {
    final DocumentReference<Map<String,dynamic>> interestedRef = FirebaseFirestore.instance
        .collection('Reqs')
        .doc(widget.id)
        .collection('Interested')
        .doc(user);
        subscription = interestedRef.snapshots().listen((snapshot) {
      setState(() {
        // means the user has already shown interest
        _interested = snapshot.exists;
      });
    });
  }

  void updateInterest() {
    final interestedRef = FirebaseFirestore.instance
        .collection('Reqs')
        .doc(widget.id)
        .collection('Interested')
        .doc(user);
    if (_interested) {
      // no need to update anything
      // this is required otherwise, everytime the button is pressed, the time will be overwritten.
    } else {
      interestedRef.set({
        'time': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 750),
      curve: Curves.linear,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.hospital,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.units} units of ${widget.bloodGroup} blood needed for ${widget.name}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: updateInterest,
                    icon: _interested
                        ? const Icon(Icons.check_circle_outline)
                        : const Icon(Icons.add_circle_outline),
                    label: _interested ? const Text("Added") : const Text("Interested"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
