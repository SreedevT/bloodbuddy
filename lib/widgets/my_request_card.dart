import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Firestore/request.dart';
import '../models/request.dart';
import '../screens/my_requests_screen.dart';
import '../utils/screen_utils.dart';

class MyRequestCard extends StatefulWidget {
  final String reqId;
  final String hospitalAddress;
  final int units;
  final String bloodGroup;
  final String patientName;
  final String status;
  // final DateTime expiryDate;
  final Function onDelete;

  //TODO in the final version, this card must take in a request object
  const MyRequestCard({
    Key? key,
    required this.reqId,
    required this.hospitalAddress,
    required this.units,
    required this.bloodGroup,
    required this.patientName,
    required this.status,
    // required this.expiryDate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<MyRequestCard> createState() => _MyRequestCardState();
}

class _MyRequestCardState extends State<MyRequestCard> {
  bool _visible = false;
  int? unitsCollected = 0;
  late String user;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeIn,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 6,
                child: requestInfo(),
              ),
              //Forces address to be 2 line most of the time, causes 1st column to take more space.
              const SizedBox(width: 10),
              Expanded(
                child: sideActions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column requestInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hospitalAddress,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Patient: ${widget.patientName}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: unitsCollectedInfo()),
            const SizedBox(width: 10),
            statusInfo(
              status: Utils.capitalizeFirstLetter(widget.status),
              color: widget.status == 'pending' ? Colors.yellow : Colors.green,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ],
    );
  }

  Container statusInfo(
      {required String status,
      required MaterialColor color,
      double? fontSize,
      FontWeight? fontWeight}) {
    const double defaultSize = 16;
    const FontWeight defaultWeight = FontWeight.bold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.shade700,
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color.shade900,
          fontSize: fontSize ?? defaultSize,
          fontWeight: fontWeight ?? defaultWeight,
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
          '/${widget.units} units collected',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column sideActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // statusInfo(status: widget.bloodGroup, color: Colors.blueGrey, fontSize: 20),
        Text(
          widget.bloodGroup,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        //TODO: add edit functionality
        circleButtonWithTooltip(
            tooltipMessage: "Edit units", onPressed: () {}, icon: Icons.edit),

        const SizedBox(height: 10),
        circleButtonWithTooltip(
          tooltipMessage: "Delete request",
          onPressed: () => deleteRequest(),
          icon: Icons.delete_forever,
          iconColor: Colors.red[400],
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
              padding: const EdgeInsets.all(10)),
          child: iconColor == null ? Icon(icon) : Icon(icon, color: iconColor),
        ));
  }

  Future<void> deleteRequest() async {
    RequestQuery(reqId: widget.reqId).deleteRequest();

    widget.onDelete();
  }
}
