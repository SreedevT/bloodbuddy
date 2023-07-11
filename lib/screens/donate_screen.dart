import 'dart:async';
import 'dart:developer';

import 'package:blood/Firestore/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Firestore/userprofile.dart';
import '../models/request.dart';
import '../widgets/request_card.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final db = FirebaseFirestore.instance;
  final String? user = FirebaseAuth.instance.currentUser!.uid;
  late final Map<String, dynamic> profile;
  late List<RequestCard> requests = [];
  StreamSubscription? queryListner;

  @override
  void initState() {
    super.initState();
    DataBase(uid: user!).getUserProfile().then((value) {
      profile = value;
      log("Current Request: ${profile['Current Request']}");
      profile['Current Request'] == null ? _getReq() : _getCurrentRequest();
    });
  }

  ///Gets the Donors Current active request. This shows only the request
  ///that has accepted the user as donor.
  Future<Set<void>> _getCurrentRequest() {
    return RequestQuery(reqId: profile['Current Request'])
        .getRequest()
        .then((value) => {
              setState(() {
                requests = [
                  ...requests,
                  RequestCard(
                    reqId: profile['Current Request'],
                    request: Request.fromMap(value),
                  )
                ];
              })
            });
  }

  @override
  void dispose() {
    //?Not canceling the subscription will lead to memory leak
    //Error stating setState() called after dispose()
    if (profile['Current Request'] == null) {
      queryListner!.cancel();
    }
    super.dispose();
  }

  Future _getReq() async {
    //TODO maybe filter out requests that belong to user.
    //although requester can also donate blood to the patient and that can be counted as donation.
    final query = db
        .collection('Reqs')
        .where('bloodGroup',
            whereIn: Request.getRecipientBloodGroups(profile['Blood Group']))
        .where('area', isEqualTo: profile['General Area']);

    queryListner = query.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            log("Added City: ${change.doc.data()}");
            final data = change.doc.data();
            Request request = Request.fromMap(data!);

            //create blood request card
            setState(() {
              requests = [
                ...requests,
                RequestCard(
                  reqId: change.doc.id,
                  request: request,
                )
              ];
            });

            log("New City: ${change.doc.data()}");
            break;
          case DocumentChangeType.modified:
            log("Modified City: ${change.doc.data()}");
            final data = change.doc.data();
            Request request = Request.fromMap(data!);
            setState(() {
              // find index of existing card
              int i = requests.indexWhere((element) {
                return element.reqId == change.doc.id;
              });
              // replace the card with the modified one
              requests[i] = RequestCard(
                reqId: change.doc.id,
                request: request,
              );
              // Make new request list
              requests = [...requests];
            });
            log("Modified City: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            setState(() {
              requests = requests.where((element) {
                return element.reqId != change.doc.id;
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
      backgroundColor: Colors.red,
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0,
        title: const Text(
          "Requests",
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 231, 231, 231),
        ),
        child: ListView(
          children: requests,
        ),
      ),
    );
  }
}
