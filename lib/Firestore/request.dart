import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class RequestQuery {
  String reqId;
  RequestQuery({required this.reqId});

  final CollectionReference request =
      FirebaseFirestore.instance.collection('Reqs');

  Future<int> getUnitsCollected() async {
    try {
      AggregateQuerySnapshot snapshot = await request
          .doc(reqId)
          .collection('Interested')
          .where('isDonor', isEqualTo: true)
          .count()
          .get();
      log("Units collected: ${snapshot.count}");
      return snapshot.count;
    } catch (e) {
      log("Error getting units collected: $e");
      return 0;
    }
  }

  Future<void> deleteRequest() async {
    log("Deleting request $reqId");
    await request
        .doc(reqId)
        .delete();
  }
  // return null;
}
