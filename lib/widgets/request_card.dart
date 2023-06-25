import 'dart:developer';

import 'package:flutter/material.dart';

class BloodRequestCard extends StatefulWidget {
  final String id;
  final String hospital;
  final int units;
  final String bloodGroup;
  final String name;

  const BloodRequestCard({
    Key? key,
    required this.id,
    required this.hospital,
    required this.units,
    required this.bloodGroup,
    required this.name,
  }) : super(key: key);

  @override
  _BloodRequestCardState createState() => _BloodRequestCardState();
}

class _BloodRequestCardState extends State<BloodRequestCard> {
  // A boolean to track the visibility of the card
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Set the visibility to true after a small delay
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      // Use the _visible value to determine the opacity
      opacity: _visible ? 1.0 : 0.0,
      // Use a duration of 500 milliseconds for the animation
      duration: const Duration(milliseconds: 500),
      // Use a linear curve for the animation
      curve: Curves.linear,
      // The child widget is your card
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // call the phone number
                    },
                    icon: const Icon(Icons.call),
                    label: Text('Call ${widget.name}'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
