import 'dart:developer';
import 'package:blood/models/request.dart';
import 'package:blood/screens/reqlist.dart';
import 'package:blood/widgets/request_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BloodRequestList extends StatefulWidget {
  const BloodRequestList({super.key});

  @override
  State<BloodRequestList> createState() => _BloodRequestListState();
}

class _BloodRequestListState extends State<BloodRequestList> {
  // final db = FirebaseFirestore.instance;

  // late List<BloodRequestCard> requests = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _getReq();
  // }

  // Future _getReq() async {
  //   final query = db
  //       .collection('requests')
  //       .where('bloodGroup', isEqualTo: 'A+')
  //       .where('area', isEqualTo: 'Azhikode');

  //   query.snapshots().listen((event) {
  //     for (var change in event.docChanges) {
  //       switch (change.type) {
  //         case DocumentChangeType.added:
  //           //create blood request card
  //           setState(() {
  //             // ! Request .add() will not cause a rebuild
  //             // requests.add(BloodRequestCard(
  //             //   hospital: change.doc['hospitalName'],
  //             //   units: change.doc['units'],
  //             //   bloodGroup: change.doc['bloodGroup'],
  //             //   name: change.doc['senderName'],
  //             // ));
  //             requests = [
  //               ...requests,
  //               BloodRequestCard(
  //                 id: change.doc.id,
  //                 hospital: change.doc['hospitalName'],
  //                 units: change.doc['units'],
  //                 bloodGroup: change.doc['bloodGroup'],
  //                 name: change.doc['senderName'],
  //               )
  //             ];
  //           });

  //           log("New City: ${change.doc.data()}");
  //           break;
  //         case DocumentChangeType.modified:
  //           setState(() {
  //             // find index of existing card
  //             int i = requests.indexWhere((element) {
  //               return element.id == change.doc.id;
  //             });
  //             // replace the card with the modified one
  //             requests[i] = BloodRequestCard(
  //               id: change.doc.id,
  //               hospital: change.doc['hospitalName'],
  //               units: change.doc['units'],
  //               bloodGroup: change.doc['bloodGroup'],
  //               name: change.doc['senderName'],
  //             );
  //             // Make new request list
  //             requests = [...requests];
  //           });
  //           log("Modified City: ${change.doc.data()}");
  //           break;
  //         case DocumentChangeType.removed:
  //           setState(() {
  //             requests = requests.where((element) {
  //               return element.id != change.doc.id;
  //             }).toList();
  //           });
  //           log("Removed City: ${change.doc.data()}");
  //           break;
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Request>>.value(
      value: Request().requestupdates,
      initialData: [],
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Blood Requests'),
        // ),
        // body: ListView(
        //   children: requests,
        // ),
        appBar: AppBar(
          title: const Text('Recent Blood Requests'),
          centerTitle: false,
        ),
        body: RequestLists(),
      ),
    );
  }
}
