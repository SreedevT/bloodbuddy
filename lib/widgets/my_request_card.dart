import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../Firestore/request.dart';
import '../models/request.dart';
import '../utils/screen_utils.dart';

class MyRequestCard extends StatefulWidget {
  final String reqId;
  final Request request;
  final Function onDelete;
  //emergency, expiry

  const MyRequestCard({
    Key? key,
    required this.reqId,
    required this.request,
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

  //Card variables
  late final String hospitalAddress;
  late final int units;
  late final String bloodGroup;
  late final String patientName;
  late final String status;
  late final String expiryDate;
  late final String expiryTime;

  //derived variables
  bool _donorsFilled = false;

  @override
  void initState() {
    super.initState();
    hospitalAddress = widget.request.hospitalName;
    units = widget.request.units;
    bloodGroup = widget.request.bloodGroup;
    patientName = widget.request.patientName;
    status = widget.request.status.name;
    expiryDate = DateFormat('dd/MM/yyyy').format(widget.request.expiryDate);
    expiryTime = DateFormat('hh:mm a').format(widget.request.expiryDate);

    RequestQuery(reqId: widget.reqId).getUnitsCollected().then((value) {
      setState(() {
        unitsCollected = value;

        //Set whether donors are filled
        _donorsFilled = unitsCollected == units;
        log("Donors filled: $_donorsFilled");
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
      child: IgnorePointer(
        ignoring: status == 'complete',
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
      ),
    );
  }

  Column requestInfo() {
    const double boxDim = 10;
    MaterialColor statusColor;
    if (status == 'pending' && !_donorsFilled) {
      statusColor = Colors.red;
    } else if (status == 'complete') {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.cyan;
    }

    String? statusText;
    if (status == 'pending' && !_donorsFilled) {
      statusText = 'Pending';
    } else if (status == 'complete') {
      statusText = 'Complete';
    } else if (_donorsFilled) {
      statusText = 'Ready';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline,
                size: 25, color: Colors.deepPurple.shade300),
            SizedBox(width: 8),
            Text(
              'Patient: ${Utils.capitalizeFirstLetter(patientName)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: boxDim),
        // Divider(thickness: 1),
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                size: 25, color: Colors.deepPurple.shade300),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hospitalAddress,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: boxDim),
        // Divider(thickness: 1),
        Row(children: [
          const SizedBox(width: 3),
          Icon(Icons.calendar_today_outlined,
              size: 18, color: Colors.deepPurple.shade300),
          const SizedBox(width: boxDim),
          Text(
            expiryDate,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: boxDim * 2),
          Icon(Icons.access_time_rounded,
              size: 18, color: Colors.deepPurple.shade300),
          const SizedBox(width: boxDim),
          Text(
            expiryTime,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ]),
        // Divider(thickness: 1),
        const SizedBox(height: boxDim),
        Row(
          children: [
            Expanded(child: unitsCollectedInfo()),
            const SizedBox(width: 10),
            statusInfo(
              status: Utils.capitalizeFirstLetter(statusText!),
              color: statusColor,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ],
    );
  }

  Container statusInfo({
    required String status,
    required MaterialColor color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    const double defaultSize = 16;
    const FontWeight defaultWeight = FontWeight.bold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.shade200,
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color.shade400,
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
          '/$units units collected',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
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
          bloodGroup,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        circleButtonWithTooltip(
            tooltipMessage: "Share",
            onPressed: () {
              String data =
                  """Hey! $patientName needs $units units of $bloodGroup blood at $hospitalAddress by $expiryDate at $expiryTime.
                  
Please contact at: ${widget.request.phone}!

Bystander name: ${widget.request.name}

This request was made using the BloodBuddy app.""";
              Share.share(data);
            },
            icon: Icons.share),

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
