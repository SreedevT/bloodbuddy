import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatefulWidget {
  final String reqId;
  final String hospitalAddress;
  final int units;
  final String bloodGroup;
  final String patientName;
  // final DateTime expiryDate;
  const RequestCard({
    Key? key,
    required this.reqId,
    required this.hospitalAddress,
    required this.units,
    required this.bloodGroup,
    required this.patientName,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    final DocumentReference<Map<String, dynamic>> interestedRef = _firestore
        .collection('Reqs')
        .doc(widget.reqId)
        .collection('Interested')
        .doc(user);
    subscription = interestedRef.snapshots().listen((snapshot) {
      setState(() {
        // means the user has already shown interest
        _interested = snapshot.exists;
        log(_interested.toString());
      });
    });
  }

  /// Updates the interested subcollection of the request
//TODO: Inform user that they will share their phone number with the requester
//Can be an info box on top
  void updateInterest() {
    final interestedRef = _firestore
        .collection('Reqs')
        .doc(widget.reqId)
        .collection('Interested')
        .doc(user);
    if (_interested) {
      //TODO: maybe add option to remove interest
      // no need to update anything
      // this is required otherwise, everytime the button is pressed, the time will be overwritten.
    } else {
      interestedRef.set({
        'time': DateTime.now(),
        'phone': _auth.currentUser!.phoneNumber,
        'isDonor': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: ListTile(
          leading: const Icon(
            Icons.bloodtype_sharp,
            color: Colors.red,
            size: 50,
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text('${widget.units} units',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                Text(widget.hospitalAddress),
                const SizedBox(
                  height: 5,
                ),
                //TODO: Add expiry date and time
                // Text('${widget.date}'),
                // Text('${widget.time}'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO: Add share functionality
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: updateInterest,
                      icon: _interested
                          ? const Icon(Icons.check_circle_outline)
                          : const Icon(Icons.add_circle_outline),
                      label: _interested
                          ? const Text("Added")
                          : const Text("Accept"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       side: const BorderSide(color: Colors.red, width: 2),
                    //     ),
                    //   ),
                    //   onPressed: () {},
                    //   child: Row(
                    //     children: [
                    //       const Text("Accept"),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
          trailing: Column(
            children: [
              Text(
                widget.bloodGroup,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
