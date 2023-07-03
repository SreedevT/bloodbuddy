import 'dart:developer';
import 'package:blood/widgets/info_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Firestore/userprofile.dart';

class InterestedUsers extends StatefulWidget {
  final String reqid;
  const InterestedUsers({Key? key, required this.reqid}) : super(key: key);

  @override
  _InterestedUsersState createState() => _InterestedUsersState();
}

class _InterestedUsersState extends State<InterestedUsers> {
  late CollectionReference interestedCollection;
  Map<String, dynamic>? fetchdata;
  List<String> ids = [];

  @override
  void initState() {
    super.initState();
    interestedCollection = FirebaseFirestore.instance
        .collection("Reqs")
        .doc(widget.reqid)
        .collection("Interested");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interested Users'),
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: interestedCollection.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
               if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) 
              {
                return const Center(child: Text("Something went wrong"));
              }
               else if (snapshot.hasData) {
                for(var doc in snapshot.data!.docs){
                  //ids.add(doc.id);
                print(doc.id);
                }
              } 
              else {
                return const Center(child: Text("No interested users"));
              }
            }
            return const Align(
              alignment: Alignment.topCenter,
              child: RefreshProgressIndicator(),
            );
          }),
    );
  }
}

