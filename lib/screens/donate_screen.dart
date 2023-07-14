import 'dart:async';
import 'dart:developer';

import 'package:blood/Firestore/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Firestore/userprofile.dart';
import '../models/profile.dart';
import '../models/request.dart';
import '../widgets/info_text.dart';
import '../widgets/request_card.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final db = FirebaseFirestore.instance;
  final String? user = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> profile = {};
  late final Map<String, dynamic> eligibility;
  late List<RequestCard> requests = [];
  StreamSubscription? queryListner;

  @override
  void initState() {
    super.initState();
    log("Donate screen profile: ${Provider.of<Profile>(context, listen: false).toJson()}");
    eligibility = Provider.of<Profile>(context, listen: false)
        .checkDonorEligibilityFunction();
    log("Eligibility: $eligibility");
    if (eligibility['eligible'] == false) {
      return;
    }
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
    if (profile['Current Request'] == null && eligibility['eligible'] == true) {
      queryListner!.cancel();
    }
    super.dispose();
  }

  Future _getReq() async {
    final query = db
        .collection('Reqs')
        .where('bloodGroup',
            whereIn: Request.getRecipientBloodGroups(profile['Blood Group']))
        .where('area', isEqualTo: profile['General Area'])
        .where('completedTime', isNull: true)
        .orderBy('expiryDate', descending: false)
        .where('expiryDate', isGreaterThan: DateTime.now());

    queryListner = query.snapshots().listen((event) {
      for (var change in event.docChanges) {
        //? This removes the request that belongs to the user
        if (change.doc.data()!['id'] == user) {
          continue;
        }

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
        child: eligibility['eligible']
            ? requests.isEmpty
            //TODO: if there are no requests Indicator will remain.
            //Rebuild using stream builder may fix this
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: requests,
                  )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InfoBox(
                    icon: Icons.info_outline,
                    text: eligibility['message'],
                    backgroundColor: const Color.fromARGB(255, 232, 245, 245),
                    padding: 30,
                    borderColor: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
