import 'dart:async';
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
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient: ${widget.patientName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.hospitalAddress,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          '0', //$unitsCollected
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/${widget.units} units needed',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 18, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        'expiryDate',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8 * 2),
                      const Icon(Icons.access_time_rounded,
                          size: 18, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        'expiryTime',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              side: BorderSide(
                                  color: Colors.grey.shade400, width: 2),
                            ),
                            elevation:
                                3, // Adjust the elevation value as needed
                            shadowColor: Colors.black.withOpacity(
                                1), // Adjust the shadow color and opacity
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(255, 241, 240, 240),
                        child: Text(
                          widget.bloodGroup,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 171, 61, 61),
                          ),
                        ),
                      ),
                    ),
                    //TODO: Add share functionality
                    const SizedBox(height: 92),
                    circleButtonWithTooltip(
                      tooltipMessage: "Share",
                      onPressed: () {},
                      icon: Icons.share,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Tooltip circleButtonWithTooltip(
      {required String tooltipMessage,
      required Function onPressed,
      required IconData icon,
      Color? iconColor}) {
    return Tooltip(
        message: tooltipMessage,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              elevation: 3,
              shadowColor: Colors.black.withOpacity(1),
              padding: const EdgeInsets.all(10)),
          child: iconColor == null ? Icon(icon) : Icon(icon, color: iconColor),
        ));
  }
}
