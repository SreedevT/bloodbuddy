import 'dart:developer';

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
  _BloodRequestCardState createState() => _BloodRequestCardState();
}

class _BloodRequestCardState extends State<BloodRequestCard> {
  // A boolean to track the visibility of the card
  bool _visible = false;
  bool _intrested = false;

  set visible(bool value) {
    setState(() {
      _visible = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // Set the visibility to true after a small delay
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      // Use the _visible value to determine the opacity
      opacity: _visible ? 1.0 : 0.0,
      // Use a duration of 500 milliseconds for the animation
      duration: const Duration(milliseconds: 750),
      // Use a linear curve for the animation
      curve: Curves.linear,
      // The child widget is your card
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
                  intrestedButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton intrestedButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Add user to subcollection with time he said yes
        FirebaseFirestore.instance
            .collection('Reqs')
            .doc(widget.id)
            .collection('Interested')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'time': DateTime.now(),
        });
        setState(() {
          _intrested = true;
        });
        log("Added user to interested list");
      },
      icon: _intrested ? const Icon(Icons.check_circle_outline) : const Icon(Icons.add_circle_outline),
      label: _intrested ? const Text("Added") : const Text("Intrested"),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
