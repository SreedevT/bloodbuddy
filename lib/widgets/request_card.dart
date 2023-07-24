import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../Firestore/request.dart';
import '../models/request.dart';
import '../utils/screen_utils.dart';

class RequestCard extends StatefulWidget {
  final String reqId;
  final Request request;
  final bool eligible;
  const RequestCard({
    Key? key,
    required this.reqId,
    required this.request,
    this.eligible = true,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _visible = false;
  bool _interested = false;
  int? unitsCollected = 0;
  late String user;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  //Card variables
  late final String hospitalAddress;
  late final int units;
  late final String bloodGroup;
  late final String patientName;
  late final String expiryDate;
  late final String expiryTime;
  late final bool isEmergency;
  late final bool eligible;

  @override
  void initState() {
    super.initState();
    hospitalAddress = widget.request.hospitalName;
    units = widget.request.units;
    bloodGroup = widget.request.bloodGroup;
    patientName = widget.request.patientName;
    expiryDate = DateFormat('dd/MM/yyyy').format(widget.request.expiryDate);
    expiryTime = DateFormat('hh:mm a').format(widget.request.expiryDate);
    isEmergency = widget.request.isEmergency;
    eligible = widget.eligible;

    RequestQuery(reqId: widget.reqId).getUnitsCollected().then((value) {
      setState(() {
        unitsCollected = value;
      });
    });

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
    double boxDim = 10;
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: isEmergency ? Colors.red[50] : Colors.white,
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
                    Text(
                        'Patient:  ${Utils.capitalizeFirstLetter(patientName)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      hospitalAddress,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 18, color: Colors.deepPurple.shade300),
                      SizedBox(width: boxDim),
                      Text(
                        expiryDate,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: boxDim * 2),
                      Icon(Icons.access_time_rounded,
                          size: 18, color: Colors.deepPurple.shade300),
                      SizedBox(width: boxDim),
                      Text(
                        expiryTime,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 6,
                    ),
                    unitsCollectedInfo(),
                    SizedBox(height: boxDim),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        eligible ?
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
                                    color: Colors.grey.shade400, width: 1),
                              ),
                              elevation: 3),
                        )
                        : const SizedBox(),
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            const Color.fromARGB(255, 241, 240, 240),
                        child: Text(
                          bloodGroup,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 171, 61, 61),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    circleButtonWithTooltip(
                        tooltipMessage: "View requisition form",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: Image.network(widget.request.fileUrl!),
                            ),
                          );
                        },
                        icon: Icons.remove_red_eye_outlined),
                    const SizedBox(height: 10),
                    circleButtonWithTooltip(
                      tooltipMessage: "Share",
                      onPressed: () {
                        Share.share(
                            '''Hey! I found a request for $bloodGroup blood at $hospitalAddress for $patientName on the BloodBuddy app. Please check it out and do contact if possible!

Bystander name: ${widget.request.name}

Contact number: ${widget.request.phone}''');
                      },
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

  Row unitsCollectedInfo() {
    return Row(
      children: [
        Text(
          '$unitsCollected',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '/$units units collected',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
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
