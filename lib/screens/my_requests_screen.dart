import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/my_request_card.dart';
import '../screens/interested_users_screen.dart';
import '../screens/requestform.dart';

class MyRequestList extends StatefulWidget {
  const MyRequestList({super.key});

  @override
  State<MyRequestList> createState() => _MyRequestListState();
}

class _MyRequestListState extends State<MyRequestList> {
  final String? uid = FirebaseAuth.instance.currentUser!.uid;
  late final Query query;

  List<MyRequestCard> requests = [];

  @override
  void initState() {
    query = FirebaseFirestore.instance
        .collection('Reqs')
        .where('id', isEqualTo: uid);
    // _getMyReq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    requests.clear();
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestForm(),
                    ));
              },
              tooltip: 'Add Request',
              icon: const Icon(Icons.add),
            )
          ],
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
                //TODO add a delete button, a way to update request fields,
                requests.add(MyRequestCard(
                  id: doc.id,
                  hospital: data['hospitalName'],
                  units: data['units'],
                  bloodGroup: data['bloodGroup'],
                  name: data['patientName'],
                  onDelete: () {
                    //? This is a callback method
                    // when widget is deleted ,it calls this method
                    // and setState is invoked in the parent widget(ListView)
                    // this reloads the page and deleted widget is removed.
                    setState(() {});
                  },
                ));
              }

              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 231, 231, 231),
                ),
                child: ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InterestedUsers(
                                      reqid: requests[index].id)));
                        }),
                        child: requests[index]);
                  },
                ),
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
