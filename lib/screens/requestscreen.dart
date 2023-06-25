import 'dart:developer';

import 'package:blood/widgets/request_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodRequestList extends StatefulWidget {
  const BloodRequestList({super.key});

  @override
  State<BloodRequestList> createState() => _BloodRequestListState();
}

class _BloodRequestListState extends State<BloodRequestList> {
  final db = FirebaseFirestore.instance;

  late List<BloodRequestCard> requests = [];

  @override
  void initState() {
    super.initState();
    _getReq();
  }

  Future _getReq() async {
    final query = db
        .collection('requests')
        .where('bloodGroup', isEqualTo: 'A+')
        .where('area', isEqualTo: 'Azhikode');
    // requestCard = const BloodRequestCard(
    //   hospital: '0',
    //   units: 0,
    //   bloodGroup: '0',
    //   name: '0',
    // );

    query.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            //create blood request card
            setState(() {
              // ! Request .add() will not cause a rebuild
              // requests.add(BloodRequestCard(
              //   hospital: change.doc['hospitalName'],
              //   units: change.doc['units'],
              //   bloodGroup: change.doc['bloodGroup'],
              //   name: change.doc['senderName'],
              // ));
              requests = [
                ...requests,
                BloodRequestCard(
                  id: change.doc.id,
                  hospital: change.doc['hospitalName'],
                  units: change.doc['units'],
                  bloodGroup: change.doc['bloodGroup'],
                  name: change.doc['senderName'],
                )
              ];
            });

            log("New City: ${change.doc.data()}");
            break;
          case DocumentChangeType.modified:
            setState(() {
              // Remove existing card
              requests = requests.where((element) {
                return element.id != change.doc.id;
              }).toList();
              // Add new card
              requests = [
                ...requests,
                BloodRequestCard(
                  id: change.doc.id,
                  hospital: change.doc['hospitalName'],
                  units: change.doc['units'],
                  bloodGroup: change.doc['bloodGroup'],
                  name: change.doc['senderName'],
                )
              ];
            });
            log("Modified City: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            setState(() {
              requests = requests.where((element) {
                return element.id != change.doc.id;
              }).toList();
            });
            log("Removed City: ${change.doc.data()}");
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: requests,
      ),
    );
  }
}
