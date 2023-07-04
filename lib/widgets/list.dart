import 'dart:developer';

import 'package:flutter/material.dart';

import '../Firestore/userprofile.dart';

class Listee extends StatefulWidget {
  final List<String> ids;

  const Listee({Key? key, required this.ids}) : super(key: key);

  @override
  State<Listee> createState() => _ListeeState();
}

class _ListeeState extends State<Listee> {
  List<Map<String, dynamic>> userDataList = [];
  // late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    userDataList.clear();
    for (String id in widget.ids) {
      try {
        Map<String, dynamic> data = await DataBase(uid: id).getUserProfile();
        log("Intersted users: ${data.toString()}");
        if (data.isNotEmpty) {
          setState(() {
            userDataList.add(data);
          });
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDataList.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> userData = userDataList[index];
        return Card(
          child: ListTile(
            title: Text("""DETAILS
                
First Name: ${userData['First Name'] ?? 'loading...'}
Blood Group: ${userData['Blood Group'] ?? 'loading...'}"""),
            subtitle: Text("""
Additonal Info

 Area : ${userData['General Area'] ?? 'loading...'}
 Age: ${userData['Age'] ?? 'loading...'}
 Date of birth: ${userData['Date of Birth'].toDate() ?? 'loading...'}
 Weight: ${userData['Weight'] ?? 'loading...'}"""),
          ),
        );
      },
    );
  }
}
