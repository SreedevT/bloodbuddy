import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/request_card.dart';

class MyRequestList extends StatefulWidget {
  const MyRequestList({super.key});

  @override
  State<MyRequestList> createState() => _MyRequestListState();
}

class _MyRequestListState extends State<MyRequestList> {
  final String? uid = FirebaseAuth.instance.currentUser!.uid;
  late final Query query;

  List<BloodRequestCard> requests = [];

  @override
  void initState() {
    query = FirebaseFirestore.instance
        .collection('Reqs')
        .where('id', isEqualTo: uid);
    // _getMyReq();
    super.initState();
  }

//TODO do this whole thing with FutureBuilder
//THIS IS PAIN
  // Future _getMyReq() async {
  //   final query = FirebaseFirestore.instance
  //       .collection('Reqs')
  //       .where('id', isEqualTo: uid);
  //   await query.get().then((snapshot) {
  //     for (var doc in snapshot.docs) {
  //       var data = doc.data();
  //       log("added: $data");
  //       requests.add(BloodRequestCard(
  //         id: data['id'],
  //         hospital: data['hospitalName'],
  //         units: data['units'],
  //         bloodGroup: data['bloodGroup'],
  //         name: data['patientName'],
  //       ));
  //     }
  //     setState(() {
  //       requests = [...requests];
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    requests.clear();
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: query.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            // if (snapshot.hasData && !snapshot.data.docs.isEmpty) {
            //   return Text("Document does not exist");
            // }

            if (snapshot.connectionState == ConnectionState.done) {
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                log("added: $data");
                //TODO remove intrested button
                //TODO add a delete button, a way to update request fields,
                //TODO and a way to see who has is intrested in the request
                requests.add(BloodRequestCard(
                  id: data['id'],
                  hospital: data['hospitalName'],
                  units: data['units'],
                  bloodGroup: data['bloodGroup'],
                  name: data['patientName'],
                ));
              }

              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return requests[index];
                },
              );
            }

            return const Align(
              alignment: Alignment.topCenter,
              child: RefreshProgressIndicator(),
            );
          },
        ));
  }
}
