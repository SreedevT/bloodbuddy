import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestedUsers extends StatefulWidget{
  final String reqid;
  const InterestedUsers({Key? key, required this.reqid}) : super(key: key);

  @override
  _InterestedUsersState createState() => _InterestedUsersState();
}

class _InterestedUsersState extends State<InterestedUsers> {
  late CollectionReference interestedReference;
  late Stream st;

  @override
  void initState(){
    super.initState();
    CollectionReference interestedReference = FirebaseFirestore.instance.collection("Reqs").
    doc(widget.reqid).
    collection("Interested");
  }

  //TODO: make a list of interested users

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interested Users'),
        centerTitle: false,
      ),
    );
  }
}