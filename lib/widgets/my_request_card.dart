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
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    //TODO Implement edit function
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => deleteRequest(),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteRequest() async {
    log("Deleting request ${widget.id}");
    await FirebaseFirestore.instance
        .collection('Reqs')
        .doc(widget.id)
        .delete();

    widget.onDelete();
  }
}
