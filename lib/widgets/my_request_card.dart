import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRequestCard extends StatefulWidget {
  final String id;
  final String hospital;
  final int units;
  final String bloodGroup;
  final String name;
  final Function onDelete;

  //TODO in the final version, this card must take in a request object
  const MyRequestCard({
    Key? key,
    required this.id,
    required this.hospital,
    required this.units,
    required this.bloodGroup,
    required this.name,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<MyRequestCard> createState() => _MyRequestCardState();
}

class _MyRequestCardState extends State<MyRequestCard> {
  bool _visible = false;
  late String user;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!.uid;
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 750),
      curve: Curves.linear,
      //TODO: using expansion_tile_card package, add edit and delete buttons
      //so that they are hidden and only shown when the card is expanded
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hospital,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.units} units of ${widget.bloodGroup} blood needed for ${widget.name}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //TODO: add edit functionality
                    Tooltip(
                      message: 'Edit units',
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(
                              side: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(10)),
                        child: const Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Tooltip(
                      message: 'Delete request',
                      child: ElevatedButton(
                          onPressed: () => deleteRequest(),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(10)),
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.red[400],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteRequest() async {
    log("Deleting request ${widget.id}");
    await FirebaseFirestore.instance.collection('Reqs').doc(widget.id).delete();

    widget.onDelete();
  }
}
