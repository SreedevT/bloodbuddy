import 'package:blood/Firestore/request.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/info_text.dart';
import '../widgets/interested_users_list.dart';

class InterestedUsers extends StatefulWidget {
  final String reqid;
  const InterestedUsers({Key? key, required this.reqid}) : super(key: key);

  @override
  State<InterestedUsers> createState() => _InterestedUsersState();
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
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              'my_requests',
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
        future: interestedCollection.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            } else if (snapshot.hasData) {
              //? Not clearing leads to duplication of data
              ids.clear();
              for (var doc in snapshot.data!.docs) {
                ids.add(doc.id);
              }
              if (ids.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InfoBox(
                      icon: Icons.info_outline,
                      text: "No one is interested yet! Please wait",
                      backgroundColor: Color.fromARGB(255, 232, 245, 245),
                      padding: 30,
                      borderColor: Colors.white,
                    ),
                  ),
                );
              } else {
                //? Returns a list of interested users, and the request id
                return Listee(ids: ids, reqid: widget.reqid);
              }
            } else {
              return const Center(child: Text("Something went wrong"));
            }
          }
          return const Align(
            alignment: Alignment.topCenter,
            child: RefreshProgressIndicator(),
          );
        },
      ),
    );
  }
}
